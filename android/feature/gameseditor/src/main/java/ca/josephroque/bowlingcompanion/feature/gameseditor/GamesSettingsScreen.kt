package ca.josephroque.bowlingcompanion.feature.gameseditor

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Scaffold
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.LocalLifecycleOwner
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.flowWithLifecycle
import androidx.lifecycle.lifecycleScope
import ca.josephroque.bowlingcompanion.feature.gameseditor.ui.settings.GamesSettings
import ca.josephroque.bowlingcompanion.feature.gameseditor.ui.settings.GamesSettingsTopBar
import kotlinx.coroutines.launch
import java.util.UUID

@Composable
internal fun GamesSettingsRoute(
	onDismissWithResult: (UUID) -> Unit,
	modifier: Modifier = Modifier,
	viewModel: GamesSettingsViewModel = hiltViewModel(),
) {
	val gamesSettingsScreenState by viewModel.uiState.collectAsStateWithLifecycle()

	val lifecycleOwner = LocalLifecycleOwner.current
	LaunchedEffect(Unit) {
		lifecycleOwner.lifecycleScope.launch {
			viewModel.events
				.flowWithLifecycle(lifecycleOwner.lifecycle, Lifecycle.State.STARTED)
				.collect {
					when (it) {
						is GamesSettingsScreenEvent.DismissedWithResult -> onDismissWithResult(it.gameId)
					}
				}
		}
	}

	GamesSettingsScreen(
		state = gamesSettingsScreenState,
		onAction = viewModel::handleAction,
		modifier = modifier,
	)
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun GamesSettingsScreen(
	state: GamesSettingsScreenUiState,
	onAction: (GamesSettingsScreenUiAction) -> Unit,
	modifier: Modifier = Modifier,
) {
	val scrollBehavior = TopAppBarDefaults.pinnedScrollBehavior()

	Scaffold(
		topBar = {
			GamesSettingsTopBar(
				onAction = { onAction(GamesSettingsScreenUiAction.GamesSettings(it)) },
				scrollBehavior = scrollBehavior,
			)
		},
		modifier = modifier.nestedScroll(scrollBehavior.nestedScrollConnection),
	) { padding ->
		when (state) {
			GamesSettingsScreenUiState.Loading -> Unit
			is GamesSettingsScreenUiState.Loaded -> GamesSettings(
				state = state.gamesSettings,
				onAction = { onAction(GamesSettingsScreenUiAction.GamesSettings(it)) },
				modifier = Modifier.padding(padding),
			)
		}
	}
}