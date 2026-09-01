package com.example.feature.profile.presentation

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import org.koin.androidx.compose.koinViewModel

/**
 * Template — the Root / Screen split.
 *
 * Root is stateful and knows the ViewModel. Screen is pure: it takes state and one onAction lambda,
 * so it previews and tests with no ViewModel and no DI graph. Never call a ViewModel from Screen.
 *
 * Copy, rename, delete this comment.
 */

@Composable
fun ProfileRoot(
    onNavigateToEdit: (String) -> Unit,
    modifier: Modifier = Modifier,
    viewModel: ProfileViewModel = koinViewModel(),
) {
    val state by viewModel.state.collectAsStateWithLifecycle()

    // One-time effects, consumed exactly once. This is why they are not in state.
    ObserveAsEvents(viewModel.events) { event ->
        when (event) {
            is ProfileEvent.NavigateToEdit -> onNavigateToEdit(event.profileId)
            is ProfileEvent.ShowMessage -> { /* snackbar */ }
        }
    }

    ProfileScreen(state = state, onAction = viewModel::onAction, modifier = modifier)
}

@Composable
fun ProfileScreen(
    state: ProfileState,
    onAction: (ProfileAction) -> Unit,
    // First optional parameter, applied to the outermost node. Without it a caller has to wrap
    // this in a Box to position it, which changes the layout in ways neither of you intended.
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier.fillMaxSize().padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(12.dp),
    ) {
        when {
            state.isLoading -> CircularProgressIndicator()

            state.errorMessage != null -> {
                Text(text = state.errorMessage.asString())
                Button(onClick = { onAction(ProfileAction.Retry) }) {
                    Text(text = "Retry")
                }
            }

            // The state everyone forgets. A blank screen the user cannot explain is a bug.
            state.isEmpty -> Text(text = "Nothing here yet.")

            state.profile != null -> {
                Text(text = state.profile.displayName)
                Text(text = state.profile.handle)
                Button(onClick = { onAction(ProfileAction.EditClicked) }) {
                    Text(text = "Edit profile")
                }
            }
        }
    }
}

// Preview every state, not just the happy path — the happy path is the one that already works.

@Preview(name = "Content")
@Composable
private fun ProfileScreenContentPreview() {
    AppTheme {
        ProfileScreen(
            state = ProfileState(
                profile = ProfileUi("1", "Ada Lovelace", "@ada", null),
            ),
            onAction = {},
        )
    }
}

@Preview(name = "Loading")
@Composable
private fun ProfileScreenLoadingPreview() {
    AppTheme { ProfileScreen(state = ProfileState(isLoading = true), onAction = {}) }
}

@Preview(name = "Error")
@Composable
private fun ProfileScreenErrorPreview() {
    AppTheme {
        ProfileScreen(
            state = ProfileState(errorMessage = UiText.Dynamic("No internet connection")),
            onAction = {},
        )
    }
}
