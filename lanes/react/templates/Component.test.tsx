/**
 * Template — component behavior tests.
 *
 * Test what the user does, not how the component does it. Every query below survives a refactor
 * of the markup; a `.querySelector('.card')` would not, and it never proved the card was
 * reachable in the first place.
 *
 * Copy, rename to match the component, delete this comment.
 */

import { describe, expect, it, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

import { UserCard } from './UserCard';

const user = {
  id: 'u_1',
  name: 'Ada Lovelace',
  email: 'ada@example.com',
};

describe('UserCard', () => {
  it('shows the name and email', () => {
    render(<UserCard user={user} />);

    expect(screen.getByText('Ada Lovelace')).toBeVisible();
    expect(screen.getByText('ada@example.com')).toBeVisible();
  });

  it('renders as a plain card when it is not selectable', () => {
    render(<UserCard user={user} />);

    // No handler means no button — a non-interactive element should not be in the tab order.
    expect(screen.queryByRole('button')).not.toBeInTheDocument();
  });

  it('calls onSelect with the user id when activated', async () => {
    const onSelect = vi.fn();
    const person = userEvent.setup();
    render(<UserCard user={user} onSelect={onSelect} />);

    await person.click(screen.getByRole('button', { name: /open ada lovelace's profile/i }));

    expect(onSelect).toHaveBeenCalledExactlyOnceWith('u_1');
  });

  it('is operable by keyboard alone', async () => {
    const onSelect = vi.fn();
    const person = userEvent.setup();
    render(<UserCard user={user} onSelect={onSelect} />);

    await person.tab();
    expect(screen.getByRole('button')).toHaveFocus();

    await person.keyboard('{Enter}');
    expect(onSelect).toHaveBeenCalledOnce();
  });
});
