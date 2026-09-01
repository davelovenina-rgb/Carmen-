/**
 * Template — a feature hook.
 *
 * The hook holds the logic: fetching, state, and the actions a component can take. The component
 * gets a result and renders it.
 *
 * Note the shape of `state`: a discriminated union, not three parallel booleans. Booleans permit
 * `isLoading && isError && data`, which is nonsense the type system should refuse. A union makes
 * the impossible state unrepresentable.
 *
 * Copy, rename to `use<Feature>.ts`, delete this comment.
 */

import { useCallback, useEffect, useState } from 'react';

export interface User {
  id: string;
  name: string;
  email: string;
}

export type UserState =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'error'; error: Error }
  | { status: 'ready'; user: User };

export function useUser(userId: string | undefined) {
  const [state, setState] = useState<UserState>({ status: 'idle' });

  const load = useCallback(
    async (signal: AbortSignal) => {
      if (!userId) {
        setState({ status: 'idle' });
        return;
      }

      setState({ status: 'loading' });

      try {
        const response = await fetch(`/api/users/${userId}`, { signal });

        if (!response.ok) {
          // Say what failed and what was expected. "Error" tells nobody anything.
          throw new Error(`Failed to load user ${userId}: ${response.status} ${response.statusText}`);
        }

        // Validate at the boundary in real code (zod or equivalent) — an API that changes shape
        // should fail loudly here, not produce `undefined` three components deep.
        const user = (await response.json()) as User;
        setState({ status: 'ready', user });
      } catch (error) {
        // An aborted request is not a failure — the component simply went away.
        if (error instanceof DOMException && error.name === 'AbortError') return;
        setState({ status: 'error', error: error instanceof Error ? error : new Error(String(error)) });
      }
    },
    [userId],
  );

  useEffect(() => {
    // AbortController so a resolved promise cannot set state on a component that is gone.
    const controller = new AbortController();
    void load(controller.signal);
    return () => controller.abort();
  }, [load]);

  const retry = useCallback(() => {
    const controller = new AbortController();
    void load(controller.signal);
  }, [load]);

  return { state, retry } as const;
}
