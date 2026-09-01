package com.example.feature.profile.presentation

import androidx.compose.runtime.Immutable
import kotlinx.collections.immutable.ImmutableList
import kotlinx.collections.immutable.persistentListOf

/**
 * Template — State, Action, and Event for one screen.
 *
 * State is everything the UI renders. Action is everything the user can do. Event is a one-time
 * effect that must NOT live in state: state is re-read on every recomposition, so a navigation
 * instruction stored there fires again on rotation.
 *
 * Copy, rename, delete this comment.
 */

@Immutable
data class ProfileState(
    val isLoading: Boolean = false,
    val profile: ProfileUi? = null,
    // ImmutableList, not List — List is unstable to the Compose compiler and defeats skipping.
    val badges: ImmutableList<BadgeUi> = persistentListOf(),
    val errorMessage: UiText? = null,
) {
    val isEmpty: Boolean get() = !isLoading && profile == null && errorMessage == null
}

@Immutable
data class ProfileUi(
    val id: String,
    val displayName: String,
    val handle: String,
    val avatarUrl: String?,
)

@Immutable
data class BadgeUi(val id: String, val label: UiText)

/** Everything the user can do on this screen. Sealed, so `when` over it is exhaustive. */
sealed interface ProfileAction {
    data object Load : ProfileAction
    data object Retry : ProfileAction
    data object EditClicked : ProfileAction
    data class BadgeClicked(val badgeId: String) : ProfileAction
}

/**
 * One-time effects only. If it should survive rotation and be re-rendered, it belongs in State.
 * If it should happen exactly once, it belongs here.
 */
sealed interface ProfileEvent {
    data class NavigateToEdit(val profileId: String) : ProfileEvent
    data class ShowMessage(val message: UiText) : ProfileEvent
}
