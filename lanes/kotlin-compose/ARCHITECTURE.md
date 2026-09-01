# Kotlin / Compose Lane — Architecture

## Module layout — feature first, then layer

```
:app                              assembles everything; owns DI wiring and navigation
:build-logic                      Gradle convention plugins

:core:domain                      models, repository interfaces, Result — depends on NOTHING
:core:data                        HttpClient, database, shared data plumbing
:core:presentation                design system, shared composables, UiText

:feature:profile:domain           this feature's use cases and contracts
:feature:profile:data             this feature's repository implementation
:feature:profile:presentation     this feature's ViewModels and composables
```

**Code lives in a feature module until a second feature needs it** — then it moves to the matching
`core` submodule. Promoting early creates a shared module that nobody owns and everybody is afraid
to touch.

## Dependency rules — enforced by the build, not by good intentions

```
presentation  →  domain  ←  data
```

- **`domain` depends on nothing.** No Android, no Ktor, no Room, no Compose, no coroutines-android.
  That is what makes it testable in milliseconds and portable to another platform.
- `data` depends on `domain`. Never on `presentation`.
- `presentation` depends on `domain`. **Never on `data`** — it talks to interfaces and receives an
  implementation through DI.
- **A feature never depends on another feature.** Cross-feature communication goes through `:app`
  (navigation callbacks) or `:core`.
- No cycles. Gradle will refuse them; do not launder one through a shared `util` module.

The payoff is concrete: swap Ktor for something else and only `:core:data` and the feature `data`
modules change. Nothing in `domain` or `presentation` knows the difference.

## Data flow, end to end

```
Composable  ──onAction──▶  ViewModel  ──▶  UseCase  ──▶  Repository ──▶ DataSource ──▶ network/db
    ▲                          │                              │
    └────── StateFlow<State> ──┘                              │
    ◀────── Channel<Event> ────┘                    Result<Domain, DataError>
```

- **DataSource** = one transport concern. One HTTP client, one DAO. Nothing else.
- **Repository** = combines sources, maps to domain, decides caching and offline behavior.
- **UseCase** = one business rule, when there is a real rule. A use case that only forwards to a
  repository is ceremony — skip it and call the repository.

**DTOs and entities never leave the data layer.** Explicit mappers sit at the boundary. A domain
model carrying a `@SerialName` annotation is a leaked abstraction, and it spreads: the next
developer adds one more field for the API's convenience, and now the domain model is the API
contract.

## Error handling across layers

```kotlin
// :core:domain
sealed interface Result<out D, out E : Error> {
    data class Success<out D>(val data: D) : Result<D, Nothing>
    data class Failure<out E : Error>(val error: E) : Result<Nothing, E>
}

sealed interface DataError : Error {
    enum class Network : DataError { NO_INTERNET, TIMEOUT, SERVER, UNAUTHORIZED, UNKNOWN }
    enum class Local : DataError { DISK_FULL, NOT_FOUND, UNKNOWN }
}
```

Data returns `Result`. Domain passes it through or maps it. Presentation maps `DataError` to
`UiText` for display. **The error stays typed until the last possible moment**, so an exhaustive
`when` at the UI layer forces every case to be handled — including the one added last week.

## Dependency injection — Koin

One module per feature layer; **assembled in `:app`, never in a feature module.** A feature module
that assembles its own dependencies cannot be tested in isolation and cannot be reused.

```kotlin
// :feature:profile:data
val profileDataModule = module {
    singleOf(::ProfileRemoteDataSource)
    single<ProfileRepository> { ProfileRepositoryImpl(get(), get()) }
}

// :feature:profile:presentation
val profilePresentationModule = module {
    viewModelOf(::ProfileViewModel)
}

// :app
startKoin { modules(coreModule, profileDataModule, profilePresentationModule) }
```

Constructor injection everywhere. No service-locator lookups inside a class — that hides
dependencies from the constructor, which is the one place anyone looks for them.

`koinViewModel()` appears in `Root` composables only.

## Navigation

Type-safe routes with `@Serializable` objects. One nav graph per feature, defined in that
feature's `presentation` module. Cross-feature navigation is a **callback the feature exposes**,
wired in `:app` — the feature never names another feature's route.

## Persistence

- Room or ObjectBox, entities confined to `data`.
- **Never `fallbackToDestructiveMigration()` in a build a user runs.** That silently deletes real
  people's data. Write the migration.
- Every migration gets a test that runs it against a real prior-version database.
- Sensitive data encrypted at rest. Never in plain `SharedPreferences`.

## Testing shape

| Level | Where | Tools |
|---|---|---|
| Domain / use case | `commonTest` | JUnit 5, AssertK — no framework, no mocks, fast |
| ViewModel | `test` | JUnit 5, Turbine, AssertK, `UnconfinedTestDispatcher`, fakes |
| Repository / mapper | `test` | JUnit 5, fake data sources |
| Compose screen | `androidTest` | Compose UI Test, semantics assertions |
| E2E | `androidTest` | Compose UI Test, robot pattern |

The ViewModel row carries the most value: it is where the state machine lives, it is fast, and it
needs no device.
