# React Lane — Conventions

The rules, with the reasoning. Cursor rules `300`–`330` are the condensed enforcement layer;
this is where the *why* lives.

---

## 1. Components

**Function components only.** No class components in new code.

**Named exports, never default.** A default export breaks rename-refactors and lets every importer
pick its own name for the same thing — so `grep` stops finding all the usages.

```tsx
// yes
export function UserCard({ user }: UserCardProps) { }

// no
export default function UserCard() { }
```

One component per file; the filename matches. Keep components under ~200 lines — past that, there
is a subcomponent inside trying to get out, and it belongs in the same directory.

**Composition over prop drilling.** Pass `children` or a render prop before threading data through
three layers. A prop that exists only to be forwarded is a design smell.

### Presentational vs container

A component either **renders** or it **orchestrates** — never both. Data fetching, mutations, and
business logic live in hooks. The component receives the result and renders it.

This is what makes a component testable without a network, previewable in isolation, and reusable
somewhere the data comes from elsewhere.

## 2. TypeScript

`strict: true`. Non-negotiable.

- **No `any`.** Use `unknown` and narrow it. `any` disables the compiler exactly where you most
  need it.
- **No `!`** to silence the compiler. If a value can be null, handle null.
- **Discriminated unions for anything with modes.** This is the single highest-value TypeScript
  pattern in a React codebase:

  ```ts
  type Async<T> =
    | { status: 'idle' }
    | { status: 'loading' }
    | { status: 'error'; error: Error }
    | { status: 'ready'; data: T };
  ```

  Three separate booleans (`isLoading`, `isError`, `data`) permit `isLoading && isError && data`,
  which is nonsense the type system should have refused. A union makes the impossible state
  unrepresentable — which is the whole point of having types.

- `type` for unions and utilities, `interface` for extensible object shapes. Be consistent inside
  a file; the argument between them is not worth having twice.

## 3. Hooks

Rules of Hooks are absolute: top level only, never inside a condition, loop, or callback.

**`useEffect` is for synchronizing with something outside React.** It is not for deriving state.
Most `useEffect` calls in most codebases should not exist:

```tsx
// wrong — an extra render, and two sources of truth that drift
const [fullName, setFullName] = useState('');
useEffect(() => setFullName(`${first} ${last}`), [first, last]);

// right
const fullName = `${first} ${last}`;
```

Every effect declares its **full** dependency array. Do not silence the exhaustive-deps rule — if
the honest dependency array causes a loop, the effect is in the wrong place, and the lint rule
just told you so.

Every effect that subscribes, sets a timer, or opens anything returns a cleanup function.

Custom hooks start with `use` and live in `hooks/`. A hook used by exactly one component can live
beside it.

## 4. State

Walk this ladder top to bottom and stop at the first one that works. Reaching for a global store
first is how a codebase ends up with everything in one place and nothing testable.

| Kind of state | Where it belongs |
|---|---|
| Derived | **Compute during render.** Not state at all. |
| One component's UI concern | `useState` |
| Related fields changing together | `useReducer` |
| Shared by a subtree, rarely changes | Context |
| Server data | A query library |
| Genuinely global client state | A store — last resort |

**Server state is not client state.** Caching, staleness, refetching, and invalidation are solved
problems with well-tested libraries. Hand-rolling them out of `useEffect` and `useState` produces
a stale-data bug that only shows up for a user with two tabs open.

Context is not a state manager. Every consumer re-renders when the value changes — split contexts
by update frequency, or use a store.

## 5. Async

Every async call handles **loading, error, and empty**. An unhandled empty state is a blank screen
the user cannot explain and cannot report usefully.

- Model it as a discriminated union (§2).
- Abort in-flight requests on unmount with `AbortController`, so a resolved promise cannot set
  state on a component that is gone.
- Never `await` inside a loop when the calls are independent — `Promise.all`.
- Retry with backoff for transient failures, and give up visibly rather than spinning forever.

## 6. Forms

Controlled inputs by default. Validate on blur and on submit, not on every keystroke — keystroke
validation shouts at someone still typing their email.

Disable submit while submitting. Double-submit is a real bug that produces duplicate records, not
a hypothetical.

## 7. Performance — in this order

1. **Fix the actual cause.** State too high in the tree, an object or array literal created inline
   in props, a context that changes too often.
2. **Split the component** so less of it re-renders.
3. **Then** `memo` / `useMemo` / `useCallback`.

Memoizing first hides the structural problem and adds real cost — every memo is a comparison and
a retained reference. Measure with the Profiler before optimizing. A guess about performance is
still a guess.

Other real wins: stable `key` on every list item (array index is a bug waiting for a reorder),
lazy-loaded routes, explicit image dimensions to stop layout shift, and watching the bundle when
adding a dependency.

## 8. Accessibility

Accessibility is correctness. A control a keyboard cannot reach is broken in the same way a
function that throws is broken. Detail lives in `.cursor/rules/330-react-a11y-perf.mdc`; the short
version:

Semantic elements first, ARIA only when no element fits. Never `<div onClick>`. Real `<label>` on
every input — a placeholder disappears the moment someone types. Visible focus. Contrast 4.5:1.
44×44 px touch targets. Respect `prefers-reduced-motion`.

## 9. Testing

Vitest + React Testing Library; Playwright for E2E. **Test what the user does, not how the
component does it.**

Query by role → label → text → test id (last resort, with a reason). `userEvent`, not
`fireEvent`. Mock at the network boundary with MSW, never your own modules — mocking your own
module tests the mock. Every bug fix starts with a failing test.

Full detail in `.cursor/rules/320-react-testing.mdc`.
