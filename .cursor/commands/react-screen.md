Scaffold a new React feature, following this repository's conventions.

Read `lanes/react/CONVENTIONS.md` and `lanes/react/ARCHITECTURE.md` first, and use the templates in
`lanes/react/templates/`.

Ask me for the feature name and what it does before generating anything.

Produce:

```
src/features/<feature>/
  components/<Feature>.tsx        pure presentational, named export, props typed
  hooks/use<Feature>.ts           the logic — data, state, actions
  api/<feature>Api.ts             data access, typed responses
  types.ts                        the feature's types
  index.ts                        the public surface, nothing else exported
  components/<Feature>.test.tsx   behavior tests, RTL, queried by role
```

Non-negotiables:

- Named exports only, no default exports
- Props explicitly typed, no `any`
- Async state as a discriminated union — never three parallel booleans
- Loading, error, **and empty** states all rendered
- Every interactive element keyboard-reachable, every input labelled
- Tests query by role and text, never by class or test id unless there is no alternative

Present the plan with every file path listed and **STOP**. No files are created until I say GO.
