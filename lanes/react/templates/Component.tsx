/**
 * Template — a presentational component.
 *
 * It renders. It does not fetch, mutate, or decide. Everything it needs arrives as props, which
 * is what makes it previewable, testable without a network, and reusable somewhere the data
 * comes from a different place.
 *
 * Copy, rename the file and the component to match, delete this comment.
 */

import type { ReactNode } from 'react';

export interface UserCardProps {
  /** The user to display. */
  user: {
    id: string;
    name: string;
    email: string;
    avatarUrl?: string;
  };
  /** Optional trailing content — actions, a badge, a menu. */
  actions?: ReactNode;
  /** Called when the card is activated. Omit to render a non-interactive card. */
  onSelect?: (userId: string) => void;
  /** Extra classes from the parent. Always accept this on a reusable component. */
  className?: string;
}

export function UserCard({ user, actions, onSelect, className }: UserCardProps) {
  // A card that does something must be a real button — not a div with a click handler.
  // A div is not focusable, not keyboard-operable, and invisible to assistive technology.
  const interactive = Boolean(onSelect);

  const content = (
    <>
      {user.avatarUrl ? (
        <img
          src={user.avatarUrl}
          alt=""            /* decorative: the name is right there in text */
          width={40}
          height={40}       /* explicit dimensions stop layout shift */
          loading="lazy"
        />
      ) : null}

      <div>
        <span>{user.name}</span>
        <span>{user.email}</span>
      </div>

      {actions}
    </>
  );

  if (!interactive) {
    return <div className={className}>{content}</div>;
  }

  return (
    <button
      type="button"
      className={className}
      onClick={() => onSelect?.(user.id)}
      aria-label={`Open ${user.name}'s profile`}
    >
      {content}
    </button>
  );
}
