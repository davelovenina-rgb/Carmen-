---
name: react-lane
description: React and TypeScript conventions for this repository — component structure, state placement, data fetching, testing with RTL, and accessibility. Use when writing, reviewing, or scaffolding any React, TSX, or frontend TypeScript work.
paths: "**/*.tsx, **/*.jsx, **/*.ts, **/*.css"
---

# React Lane

Full detail: `lanes/react/CONVENTIONS.md`, `lanes/react/ARCHITECTURE.md`.
Templates: `lanes/react/templates/`. Checklist: `lanes/react/CHECKLIST.md`.

## Non-negotiables

- Function components, **named exports**, one per file, under ~200 lines
- `strict` TypeScript. No `any` — `unknown` and narrow. No `!` to silence the compiler.
- **Async state as a discriminated union**, never three parallel booleans
- **Loading, error, and empty** all rendered. An unhandled empty state is a blank screen.
- Rules of Hooks absolute. Full dependency arrays — fix the dependency, never silence the lint.
- Every effect that subscribes or opens anything returns a cleanup
- Composition over prop drilling
- Keyboard reachable, labelled, contrast-checked — accessibility is correctness, not polish

## Where state lives — first match wins

| Kind | Where |
|---|---|
| Derived from props or other state | **Compute during render.** Not state. |
| One component's own UI concern | `useState` |
| Related fields changing together | `useReducer` |
| Shared by a subtree, rarely changes | Context |
| Server data | A query library — never hand-rolled |
| Genuinely global client state | A store — last resort |

**Server state is not client state.** Cache, staleness, refetch, invalidation are solved. Do not
rebuild them out of `useEffect` and `useState`.

## The most common bug in a React codebase

State that could have been computed:

```tsx
// wrong — two sources of truth that will drift apart
const [count, setCount] = useState(0);
useEffect(() => setCount(items.length), [items]);

// right — one source of truth
const count = items.length;
```

## Structure

```
src/features/<feature>/
  components/  hooks/  api/  types.ts  index.ts
```

Cross-feature imports go through `index.ts` only. Reaching into another feature's internals is
exactly what this layout exists to prevent.

## Testing

Vitest + React Testing Library; Playwright for E2E. **Test what the user does, not how the
component does it.** Query by role → label → text → test id (last resort, with a reason).
`userEvent`, not `fireEvent`. Mock at the network boundary (MSW), never your own modules.
Every bug fix starts with a failing test.

## Performance — in this order

1. Fix the actual re-render cause (state too high, object literal in props)
2. Split the component
3. *Then* `memo` / `useMemo` / `useCallback`

Memoizing first hides the structural problem and adds its own cost. Profile before optimizing.

## Scaffold a feature

`/react-screen` — reads the conventions, asks what the feature does, and proposes every file path
before writing anything.
