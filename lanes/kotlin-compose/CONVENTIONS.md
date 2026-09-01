# Kotlin / Compose Lane — Conventions

The rules, with the reasoning. Cursor rules `400`–`440` are the condensed enforcement layer;
this is where the *why* lives.

---

## 1. Null safety

**No `!!`. Ever.** It is a crash whose stack trace points at the assertion, not at the code that
allowed null in the first place — so it costs you the debugging session as well as the crash.

Handle null: `?.`, `?:`, `requireNotNull(x) { "descriptive message" }`, or a smart cast after a
real check. Prefer non-null types with sensible defaults over nullable types with checks
scattered across twelve call sites.

`lateinit` is for genuine framework injection only, never for "I will set this shortly."

## 2. Immutability

`val` by default; `var` needs a reason. Data classes for models, `copy()` to change a field.

**Never expose a mutable type across a boundary.** A caller that *can* mutate your internal
collection eventually *will*, from a thread you did not expect:

```kotlin
private val _state = MutableStateFlow(ScreenState())
val state: StateFlow<ScreenState> = _state.asStateFlow()

private val _items = mutableListOf<Item>()
val items: List<Item> get() = _items.toList()
```

## 3. Errors — typed, not thrown

Expected failures are values, not exceptions. A network call that can 404 is not exceptional; it
is Tuesday. Use a typed `Result<D, E>` with a sealed error interface, so `when` is exhaustive and
a new error case becomes a **compile error** rather than a silent fallthrough.

Exceptions are reserved for the genuinely unrecoverable.

**Three things that are always findings:**

- `catch (_: Exception) {}` — an empty catch. The failure happened and nobody will ever know.
- `catch (t: Throwable)` — swallows `CancellationException`, breaks structured concurrency, and
  produces bugs nobody can reproduce because they only appear when something is cancelled.
- A `null` return that means "something went wrong." Null means absent; it does not carry a reason.

## 4. Coroutines

Structured concurrency: every coroutine has a scope tied to a lifecycle. **No `GlobalScope`** —
it outlives everything and leaks quietly.

Suspend functions are **main-safe**: the function moves itself to the right dispatcher. A caller
should never have to know which thread a function wants.

Inject dispatchers rather than hardcoding them, so a test can substitute a test dispatcher and
run deterministically.

Always rethrow `CancellationException`. `Flow` for streams, `suspend fun` for one-shot work — do
not wrap a single call in a flow because it looked symmetrical.

## 5. The UI is dumb

**Composables render state and forward actions. Nothing else.** Zero business logic, zero data
transformation, minimal side effects. All state lives in the ViewModel.

This is the load-bearing rule of the whole lane. Everything below follows from it.

### The Root / Screen split

```kotlin
@Composable
fun ProfileRoot(viewModel: ProfileViewModel = koinViewModel()) {
    val state by viewModel.state.collectAsStateWithLifecycle()
    ProfileScreen(state = state, onAction = viewModel::onAction)
}

@Composable
fun ProfileScreen(state: ProfileState, onAction: (ProfileAction) -> Unit) { /* pure UI */ }
```

`Root` is stateful and knows the ViewModel. `Screen` is pure — it takes state and a single
`onAction`, and can be previewed and tested with no ViewModel and no DI graph.

**Never call a ViewModel from inside `Screen`.** The moment you do, previews break and the test
needs a whole dependency graph.

## 6. MVI — State, Action, Event

| Piece | Shape | Purpose |
|---|---|---|
| **State** | one `data class` | everything the UI renders |
| **Action** | `sealed interface` | everything the user can do |
| **Event** | `sealed interface` | one-time effects: navigate, snackbar, toast |
| **ViewModel** | `StateFlow<State>` + `onAction` + `Channel<Event>` | the orchestrator |

**State vs Event is the distinction that matters most.** State is re-read on every recomposition,
so a navigation instruction stored in state fires again on rotation — the classic
"why did it navigate twice" bug. One-time effects go through a `Channel`, consumed exactly once.

`onAction` uses an **exhaustive `when` with no `else`**. Add an action and forget to handle it, and
the compiler tells you — instead of a user tapping a button that silently does nothing.

State updates go through `_state.update { it.copy(...) }`, which is atomic. Assigning
`_state.value` from more than one place is a lost-update bug waiting for a race.

The ViewModel knows nothing about Android UI: no `Context`, no `View`, no `Composable`. User-facing
strings are `UiText` — a resource id or a raw string — resolved in the composable. **A ViewModel
that formats an English sentence has broken localization.**

`SavedStateHandle` for anything that must survive process death.

## 7. Recomposition and stability

Composition can run any number of times, in any order, on any thread, and be thrown away. So:

- **Never** mutate state, perform I/O, or read a changing value directly in the composition body.
- **Never** allocate there — `mutableListOf()` or an unremembered object literal creates a new
  instance every recomposition and defeats skipping entirely.
- Parameters should be **stable**: primitives, `String`, immutable data classes of stable types,
  stable lambda references.
- **`List<T>` is unstable to the compiler.** Use `ImmutableList` (kotlinx.collections.immutable)
  or annotate the wrapper `@Immutable`. This one surprises people constantly.
- Defer reads to the narrowest scope. Passing `() -> Float` instead of `Float` keeps a frequently
  changing value from recomposing a whole subtree.

### Side effects — pick the right one

| Need | Use |
|---|---|
| On enter / on key change, suspend-capable | `LaunchedEffect(key)` |
| Clean up when leaving composition | `DisposableEffect(key)` |
| Read the latest value inside a long-lived effect | `rememberUpdatedState` |
| Non-suspend work after each successful composition | `SideEffect` |
| Launch from a callback (a click) | `rememberCoroutineScope()` |

`LaunchedEffect(Unit)` runs once — confirm that is genuinely what you want and that the effect is
not silently stale when a parameter changes.

## 8. Modifier

Every public composable takes `modifier: Modifier = Modifier` as its **first optional parameter**
and applies it to its outermost layout node. Without it, a caller cannot position your component
and has to wrap it in a `Box`, which changes the layout in ways neither of you intended.

**Modifier order is not commutative.** `padding().background()` paints a smaller background than
`background().padding()`. Read modifier chains carefully at audit — this is a real bug class, not
a style question.

Never pass one modifier down to more than one child.

## 9. Previews

Every reusable composable gets a `@Preview`. Previews are documentation that cannot rot silently —
they stop compiling.

Preview the **loading, error, and empty** states too. The happy path is the one that already works.

```kotlin
@Preview(name = "Light")
@Preview(name = "Dark", uiMode = UI_MODE_NIGHT_YES)
@Composable
private fun ProfileScreenPreview() {
    AppTheme { ProfileScreen(state = ProfileState(/* sample */), onAction = {}) }
}
```

## 10. Accessibility

`contentDescription` on every meaningful image and icon button; `null` for purely decorative ones —
a decorative image with a description is noise a screen-reader user has to wade through.

Touch targets at least 48 dp. `Modifier.semantics { }` to merge or clarify. Never rely on colour
alone. Test with TalkBack, not by reading the code.

## 11. Testing

JUnit 5 · Turbine · AssertK · `kotlinx-coroutines-test` · Compose UI Test.

Backtick names that state the behavior. Turbine for every `Flow` assertion — never `first()` and
hope. **Fakes, not mocks**: a hand-written fake implementing the domain interface is more readable,
refactors cleanly, and does not encode call order as a requirement the way a strict mock does.

If a test's arrange block is longer than act and assert combined, the class under test has too
many dependencies — that is a design finding, not a test problem.

Coverage percentage is a diagnostic, not a target. A suite at 90% that never exercises an error
path is worse than one at 60% that does, because it reports confidence it has not earned.
