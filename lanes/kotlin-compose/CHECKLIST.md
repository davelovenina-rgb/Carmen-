# Kotlin / Compose Lane — Checklist

Before saying a Kotlin or Compose change is done. Every box verified, not assumed.

## Kotlin safety

- [ ] No `!!` anywhere in the diff
- [ ] No empty catch — `catch (_: Exception) {}` is a Blocker
- [ ] No `catch (Throwable)` — it swallows `CancellationException`
- [ ] `CancellationException` rethrown wherever exceptions are caught around suspend calls
- [ ] No `GlobalScope`
- [ ] `val` unless mutation is genuinely required
- [ ] Mutable types kept private; `List` / `StateFlow` exposed, not `MutableList` / `MutableStateFlow`
- [ ] Expected failures return a typed `Result`, not a thrown exception or a meaningful `null`

## MVI

- [ ] State is one data class; Action and Event are sealed interfaces
- [ ] `onAction` is an exhaustive `when` with **no `else`**
- [ ] One-time effects go through `Channel`, never `StateFlow`
- [ ] State updated with `_state.update { it.copy(...) }`
- [ ] No `Context`, `View`, or composable reference in the ViewModel
- [ ] User-facing strings are `UiText`, resolved in the composable
- [ ] Anything that must survive process death is in `SavedStateHandle`

## Compose

- [ ] `Root` / `Screen` split; `Screen` is pure and touches no ViewModel
- [ ] `modifier: Modifier = Modifier` is the first optional parameter, applied to the outer node
- [ ] Modifier chain order checked — order is not commutative
- [ ] No allocation, mutation, or I/O in the composition body
- [ ] Right effect used; `LaunchedEffect` keys are correct and not silently stale
- [ ] Unstable parameters wrapped — `ImmutableList` or `@Immutable`, not bare `List`
- [ ] `rememberSaveable` for anything that must survive configuration change
- [ ] `@Preview` for loading, error, **and** content states

## Accessibility

- [ ] `contentDescription` on every meaningful image and icon button; `null` on decorative ones
- [ ] Touch targets ≥ 48 dp
- [ ] Meaning never carried by colour alone
- [ ] Checked with TalkBack, not just by reading the code

## Architecture

- [ ] `domain` still depends on nothing — no Android, no Ktor, no Room, no Compose
- [ ] No DTO or entity leaked out of the data layer
- [ ] No feature-to-feature dependency introduced
- [ ] Koin modules assembled in `:app`, not in a feature module
- [ ] Constructor injection; no service-locator lookups inside classes

## Build

- [ ] No hardcoded version — everything through `libs.versions.toml`
- [ ] No `fallbackToDestructiveMigration()` in a build a user runs
- [ ] Migration written **and tested** if a schema changed
- [ ] No credential in a tracked file; no keystore touched
- [ ] No lint check disabled globally to fix one call site
- [ ] Release build type has no debug affordance

## Tests

- [ ] New behavior tested; every bug fix started with a failing test
- [ ] Turbine used for every Flow assertion
- [ ] Fakes, not mocks, unless there is a stated reason
- [ ] Error and empty paths covered, not just the happy path
- [ ] Suite green; `./gradlew build` clean

## Repository

- [ ] Only files named at Gate 2 were touched
- [ ] Diff read line by line, by me
- [ ] `./harness/verify.sh` passes
- [ ] No stamp written anywhere
