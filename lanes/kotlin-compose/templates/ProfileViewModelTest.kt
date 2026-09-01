package com.example.feature.profile.presentation

import app.cash.turbine.test
import assertk.assertThat
import assertk.assertions.isEqualTo
import assertk.assertions.isFalse
import assertk.assertions.isNotNull
import assertk.assertions.isTrue
import androidx.lifecycle.SavedStateHandle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.test.setMain
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test

/**
 * Template — ViewModel tests.
 *
 * Backtick names that state the behavior, so a failing test names the broken behavior in the
 * report before anyone opens the file. Turbine for every Flow assertion — never `first()` and hope.
 * A hand-written fake, not a mock: it refactors cleanly and does not encode call order as a
 * requirement.
 *
 * Copy, rename, delete this comment.
 */
@OptIn(ExperimentalCoroutinesApi::class)
class ProfileViewModelTest {

    private val dispatcher = UnconfinedTestDispatcher()

    @BeforeEach fun setUp() = Dispatchers.setMain(dispatcher)
    @AfterEach fun tearDown() = Dispatchers.resetMain()

    private fun handle() = SavedStateHandle(mapOf("profileId" to "u_1"))

    @Test
    fun `emits loading then content when the profile loads`() = runTest {
        val viewModel = ProfileViewModel(
            repository = FakeProfileRepository(profile = sampleProfile),
            savedStateHandle = handle(),
        )

        viewModel.state.test {
            assertThat(awaitItem().profile).isEqualTo(null)   // initial

            viewModel.onAction(ProfileAction.Load)

            assertThat(awaitItem().isLoading).isTrue()
            val loaded = awaitItem()
            assertThat(loaded.isLoading).isFalse()
            assertThat(loaded.profile?.displayName).isEqualTo("Ada Lovelace")
            cancelAndIgnoreRemainingEvents()
        }
    }

    @Test
    fun `surfaces an error message when the repository fails`() = runTest {
        val viewModel = ProfileViewModel(
            repository = FakeProfileRepository(error = DataError.Network.NO_INTERNET),
            savedStateHandle = handle(),
        )

        viewModel.state.test {
            skipItems(1)
            viewModel.onAction(ProfileAction.Load)
            skipItems(1)                                       // loading

            val failed = awaitItem()
            assertThat(failed.isLoading).isFalse()
            assertThat(failed.errorMessage).isNotNull()
            cancelAndIgnoreRemainingEvents()
        }
    }

    @Test
    fun `emits a navigation event exactly once when edit is tapped`() = runTest {
        val viewModel = ProfileViewModel(
            repository = FakeProfileRepository(profile = sampleProfile),
            savedStateHandle = handle(),
        )

        viewModel.events.test {
            viewModel.onAction(ProfileAction.EditClicked)

            val event = awaitItem()
            assertThat(event).isEqualTo(ProfileEvent.NavigateToEdit("u_1"))
            expectNoEvents()          // one-time means one time
            cancelAndIgnoreRemainingEvents()
        }
    }
}

/** Fake, not a mock — readable, refactor-safe, and it does not assert on call order. */
private class FakeProfileRepository(
    private val profile: Profile? = null,
    private val error: DataError? = null,
) : ProfileRepository {
    override suspend fun getProfile(id: String): Result<Profile, DataError> =
        when {
            error != null -> Result.Failure(error)
            profile != null -> Result.Success(profile)
            else -> Result.Failure(DataError.Local.NOT_FOUND)
        }
}
