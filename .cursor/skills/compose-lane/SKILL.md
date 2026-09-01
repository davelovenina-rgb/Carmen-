---
name: compose-lane
description: Kotlin and Jetpack Compose conventions for this repository — MVI state/action/event, the Root/Screen split, recomposition and stability, Koin DI, typed Result error handling, module structure, and testing with Turbine. Use when writing, reviewing, or scaffolding any Kotlin, Compose, or Android work.
paths: "**/*.kt, **/*.kts, **/libs.versions.toml"
---

# Kotlin / Compose Lane

Full detail: `lanes/kotlin-compose/CONVENTIONS.md`, `lanes/kotlin-compose/ARCHITECTURE.md`.
Templates: `lanes/kotlin-compose/templates/`. Checklist: `lanes/kotlin-compose/CHECKLIST.md`.

## Non-negotiables

- **No `!!`.** Ever. Handle null.
- **No empty catch.** `catch (_: Exception) {}` is a finding, always.
- **Never catch `Throwable`** — it swallows `CancellationException` and breaks cancellation.
- No `GlobalScope`. Structured concurrency, injected dispatchers.
- `val` by default. Expose `List` and `StateFlow`, never the mutable type.
- Typed `Result<D, E>` for expected failures. Exceptions only for the genuinely exceptional.
- **Never** `fallbackToDestructiveMigration()` in anything a user runs. That is real people's data.
- **Never** touch, move, or regenerate a keystore.

## The four pieces of every screen

| Piece | Shape | Purpose |
|---|---|---|
| **State** | one `data class` | everything the UI renders |
| **Action** | `sealed interface` | everything the user can do |
| **Event** | `sealed interface` | one-time effects only |
| **ViewModel** | `StateFlow<State>` + `onAction` + `Channel<Event>` | the orchestrator |

**State vs Event is the distinction that matters.** State re-renders on every recomposition — so a
navigation instruction stored in state fires again on rotation. One-time effects go through a
`Channel`, consumed once.

`onAction` is an **exhaustive `when` with no `else`**, so a new action becomes a compile error
instead of a silently ignored tap.

## The Root / Screen split

```kotlin
@Composable
fun ProfileRoot(viewModel: ProfileViewModel = koinViewModel()) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    ProfileScreen(state = state, onAction = viewModel::onAction)
}

@Composable
fun ProfileScreen(state: ProfileState, onAction: (ProfileAction) -> Unit) { /* pure UI */ }
```

`Screen` is pure — previewable, testable, no ViewModel, no DI. **Never call a ViewModel from
inside `Screen`.**

## Compose discipline

- **The UI is dumb.** Composables render state and forward actions. Nothing else.
- Hoist state to the lowest common ancestor that needs it.
- `rememberSaveable` for anything that must survive configuration change and process death.
- Right effect for the job: `LaunchedEffect` (keyed, suspend) · `DisposableEffect` (cleanup) ·
  `rememberUpdatedState` (latest value in a long-lived effect) · `rememberCoroutineScope` (from a
  callback). Never mutate state or do I/O in the composition body.
- Stability: `List<T>` is unstable — use `ImmutableList` or `@Immutable`. Never allocate in the
  composition body.
- `modifier: Modifier = Modifier` as the **first optional parameter** on every public composable,
  applied to the outermost node. Modifier order is not commutative.
- `@Preview` for loading, error, and content — not just the happy path.

## Layers

```
presentation  →  domain  ←  data
```

**Domain depends on nothing** — no Android, no Ktor, no Room, no Compose. That is what makes it
testable in milliseconds. DTOs and entities never leave the data layer; explicit mappers at the
boundary. A feature never depends on another feature.

Koin: one module per feature layer, assembled in `:app`, constructor injection everywhere.
`koinViewModel()` in `Root` only.

## Testing

JUnit 5 + Turbine + AssertK + `kotlinx-coroutines-test`. Backtick names that state the behavior.
Turbine for every Flow assertion. **Fakes, not mocks** — a hand-written fake implementing the
domain interface refactors cleanly and does not encode call order as a requirement.

## Scaffold a screen

`/compose-screen` — reads the conventions, asks what the screen does, and proposes every file path
before writing anything.
