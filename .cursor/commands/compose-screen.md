Scaffold a new Jetpack Compose screen, following this repository's conventions.

Read `lanes/kotlin-compose/CONVENTIONS.md` and `lanes/kotlin-compose/ARCHITECTURE.md` first, and
use the templates in `lanes/kotlin-compose/templates/`.

Ask me for the screen name, what it shows, and what the user can do on it before generating
anything.

Produce, in the feature's `presentation` module:

```
<Feature>State.kt        one data class — everything the UI renders
<Feature>Action.kt       sealed interface — everything the user can do
<Feature>Event.kt        sealed interface — one-time effects only (nav, snackbar)
<Feature>ViewModel.kt    StateFlow<State>, onAction with an exhaustive when, Channel<Event>
<Feature>Screen.kt       Root (stateful, koinViewModel) + Screen (pure) + @Preview
<Feature>ViewModelTest.kt  JUnit5 + Turbine + AssertK, fake repository
```

Non-negotiables:

- **Root / Screen split.** `Screen` takes `state` and `onAction` and never touches the ViewModel.
- `onAction` is an exhaustive `when` with **no `else`** — a new action must be a compile error.
- One-time effects go through `Channel`, never `StateFlow`. Navigation in state re-fires on rotation.
- `modifier: Modifier = Modifier` as the first optional parameter on every public composable.
- No `!!`, no empty catch, no `GlobalScope`, no `Context` in the ViewModel.
- User-facing strings as `UiText`, resolved in the composable — never formatted in the ViewModel.
- `@Preview` for the loading, error, and content states — not just the happy path.

Present the plan with every file path listed and **STOP**. No files are created until I say GO.
