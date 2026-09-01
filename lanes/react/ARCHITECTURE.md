# React Lane — Architecture

## Feature-first, not type-first

```
src/
  features/
    auth/
      components/       UI for this feature
      hooks/            feature logic — data, state, actions
      api/              data access, typed
      types.ts
      index.ts          the public surface — nothing else is importable
    profile/
    billing/
  shared/
    components/         genuinely reusable UI (Button, Modal, Field)
    hooks/              genuinely reusable hooks
    lib/                pure utilities, no React
    types/
  app/
    routes/
    providers/          context providers, query client, theme
    App.tsx
```

**Why feature-first.** Grouping by type — `components/`, `hooks/`, `utils/` at the top — means a
single feature is scattered across five directories, and deleting a feature is an archaeology
project. Grouping by feature means everything one thing needs is in one place, and removing it is
`rm -rf` on one directory.

## The `index.ts` boundary

Each feature exports its public surface from `index.ts` and nothing else:

```ts
// features/auth/index.ts
export { LoginForm } from './components/LoginForm';
export { useAuth } from './hooks/useAuth';
export type { User } from './types';
```

Other features import **only** from `features/auth`, never from `features/auth/hooks/useAuth`.

This is the rule that keeps the codebase from becoming one graph. Without it, a refactor inside
`auth` breaks `billing` in a way nobody predicted, because `billing` reached into a file it was
never meant to see.

**Code moves to `shared/` when a second feature needs it — not before.** Promoting early creates a
shared module nobody owns and everybody is afraid to change.

## Dependency direction

```
app  →  features  →  shared
```

- `shared/` imports from nothing above it. Ever.
- `features/` import from `shared/`, and from each other **only** through `index.ts`.
- `app/` wires everything together and owns routing and providers.
- **No circular imports.** A cycle usually means two features are actually one feature.

## Data flow

```
component  →  hook  →  api  →  network
    ↑                              │
    └────────── typed data ────────┘
```

- `api/` speaks HTTP and returns **typed** data. Response shapes are validated at the boundary
  (zod or equivalent) — an API that changes shape should fail loudly at the edge, not produce
  `undefined` three components deep.
- `hooks/` hold the logic and the cache.
- `components/` render.

A component never calls `fetch`. A hook never renders. The api layer never knows a component exists.

## Routing

Routes live in `app/routes/`, one file per route, each doing nothing but composing a feature's
exported entry component. A route file with business logic in it is a feature that has not been
extracted yet.

Lazy-load every route. The initial bundle should carry the shell and the first screen — nothing more.

## Providers

Provider order matters and is set once in `app/providers/`:

```
ErrorBoundary → QueryClient → Theme → Router → App
```

Every provider that can fail has an error boundary above it. A provider that throws during render
with nothing above it produces a white screen and no report.

## Testing shape

| Level | Tool | What it proves |
|---|---|---|
| Unit | Vitest | a pure function does what it says |
| Component | Vitest + RTL | a component behaves for a user |
| Integration | Vitest + RTL + MSW | a feature works end to end against a fake network |
| E2E | Playwright | the real app works in a real browser |

Most value sits in the **integration** row: a whole feature, real components, fake network. Unit
tests over-fit to implementation; E2E is slow and flaky at volume.
