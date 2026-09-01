# React Lane — Checklist

Before saying a React change is done. Every box verified, not assumed.

## Component

- [ ] Named export, one component per file, filename matches
- [ ] Under ~200 lines, or split with a reason
- [ ] Props explicitly typed — no `any`, no inline type for anything non-trivial
- [ ] `modifier`-equivalent: `className` accepted and applied if this is a reusable component
- [ ] Renders **or** orchestrates — not both
- [ ] No `fetch` inside a component

## Types

- [ ] No `any` in the diff. No `!` added to silence the compiler
- [ ] No `@ts-ignore` / `@ts-expect-error` without a comment explaining why
- [ ] Async state is a discriminated union, not parallel booleans
- [ ] `tsc --noEmit` clean

## Hooks

- [ ] Rules of Hooks respected — no conditional calls
- [ ] Full dependency arrays; exhaustive-deps not silenced anywhere
- [ ] Every subscription, timer, and listener has a cleanup
- [ ] No `useEffect` that only derives state from other state

## States rendered

- [ ] Loading
- [ ] Error — with something the user can act on
- [ ] **Empty** — the one that gets forgotten
- [ ] Success

## Accessibility

- [ ] Reachable and operable by keyboard alone, sensible tab order
- [ ] Focus visible at every stop; focus moved deliberately after route change or modal open
- [ ] Every input has a real `<label>`; every image has `alt`
- [ ] No `<div onClick>` anywhere in the diff
- [ ] Contrast ≥ 4.5:1 body, ≥ 3:1 large text and UI boundaries
- [ ] Errors announced, not signalled by colour alone
- [ ] Works at 320 px wide and at 200% zoom

## Tests

- [ ] New behavior has a test; every bug fix started with a failing test
- [ ] Queried by role/label/text — test ids only where unavoidable, with a reason
- [ ] `userEvent`, not `fireEvent`
- [ ] Network mocked at the boundary (MSW), not by mocking own modules
- [ ] Error and empty paths tested, not just the happy path
- [ ] Suite green, no `.only` or `.skip` left in

## Performance

- [ ] Every list item has a stable key — no array index
- [ ] No object or array literal created inline in props on a hot path
- [ ] Memoization only where profiling showed it was needed
- [ ] Images have explicit dimensions; heavy routes lazy-loaded
- [ ] Bundle impact considered if a dependency was added

## Repository

- [ ] Only files named at Gate 2 were touched
- [ ] Diff read line by line, by me
- [ ] Lint and format clean
- [ ] No secret, no `console.log`, no commented-out code left behind
- [ ] `./harness/verify.sh` passes
