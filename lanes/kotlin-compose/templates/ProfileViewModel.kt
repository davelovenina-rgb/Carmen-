package com.example.feature.profile.presentation

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.collections.immutable.toPersistentList
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

/**
 * Template — a ViewModel.
 *
 * Knows nothing about Android UI: no Context, no View, no composable. Talks to a domain interface,
 * never to a concrete data class. Produces UiText, never a formatted English sentence — formatting
 * a sentence here breaks localization permanently.
 *
 * Copy, rename, delete this comment.
 */
class ProfileViewModel(
    private val repository: ProfileRepository,   // a domain interface, injected
    private val savedStateHandle: SavedStateHandle,
) : ViewModel() {

    private val profileId: String = requireNotNull(savedStateHandle["profileId"]) {
        "ProfileViewModel requires a profileId argument"
    }

    private val _state = MutableStateFlow(ProfileState())
    val state: StateFlow<ProfileState> = _state.asStateFlow()

    private val _events = Channel<ProfileEvent>()
    val events = _events.receiveAsFlow()

    /**
     * Exhaustive `when`, no `else`. Add an action and forget to handle it and the compiler stops
     * you — instead of a user tapping a button that silently does nothing.
     */
    fun onAction(action: ProfileAction) {
        when (action) {
            ProfileAction.Load,
            ProfileAction.Retry -> loadProfile()

            ProfileAction.EditClicked -> viewModelScope.launch {
                _events.send(ProfileEvent.NavigateToEdit(profileId))
            }

            is ProfileAction.BadgeClicked -> viewModelScope.launch {
                _events.send(ProfileEvent.ShowMessage(UiText.Resource(R.string.badge_info)))
            }
        }
    }

    private fun loadProfile() {
        // `update` is atomic. Assigning `_state.value` from several places is a lost-update race.
        _state.update { it.copy(isLoading = true, errorMessage = null) }

        viewModelScope.launch {
            when (val result = repository.getProfile(profileId)) {
                is Result.Success -> _state.update {
                    it.copy(
                        isLoading = false,
                        profile = result.data.toUi(),
                        badges = result.data.badges.map { badge -> badge.toUi() }.toPersistentList(),
                    )
                }

                // The error is still typed here, so this `when` is exhaustive — a new DataError
                // case becomes a compile error rather than an unhandled silent failure.
                is Result.Failure -> _state.update {
                    it.copy(isLoading = false, errorMessage = result.error.toUiText())
                }
            }
        }
    }
}
