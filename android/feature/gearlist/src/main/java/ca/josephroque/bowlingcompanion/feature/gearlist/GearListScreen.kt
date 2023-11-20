package ca.josephroque.bowlingcompanion.feature.gearlist

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import ca.josephroque.bowlingcompanion.feature.gearlist.ui.GearList
import ca.josephroque.bowlingcompanion.feature.gearlist.ui.GearListTopBar
import ca.josephroque.bowlingcompanion.feature.gearlist.ui.GearListTopBarUiState
import java.util.UUID

@Composable
internal fun GearListRoute(
	onBackPressed: () -> Unit,
	onEditGear: (UUID) -> Unit,
	onAddGear: () -> Unit,
	modifier: Modifier = Modifier,
	viewModel: GearListViewModel = hiltViewModel(),
) {
	val gearListScreenState by viewModel.uiState.collectAsStateWithLifecycle()

	when (val event = viewModel.events.collectAsState().value) {
		GearListScreenEvent.Dismissed -> onBackPressed()
		is GearListScreenEvent.NavigateToAddGear -> {
			viewModel.handleAction(GearListScreenUiAction.HandledNavigation)
			onAddGear()
		}
		is GearListScreenEvent.NavigateToEditGear -> {
			viewModel.handleAction(GearListScreenUiAction.HandledNavigation)
			onEditGear(event.id)
		}
		null -> Unit
	}

	GearListScreen(
		state = gearListScreenState,
		onAction = viewModel::handleAction,
		modifier = modifier,
	)
}

@Composable
private fun GearListScreen(
	state: GearListScreenUiState,
	onAction: (GearListScreenUiAction) -> Unit,
	modifier: Modifier = Modifier,
) {
	Scaffold(
		topBar = {
			GearListTopBar(
				state = when (state) {
					GearListScreenUiState.Loading -> GearListTopBarUiState()
					is GearListScreenUiState.Loaded -> state.topBar
			  },
				onAction = { onAction(GearListScreenUiAction.GearListAction(it)) },
			)
		}
	) { padding ->
		when (state) {
			GearListScreenUiState.Loading -> Unit
			is GearListScreenUiState.Loaded ->
				GearList(
					state = state.gearList,
					onAction = { onAction(GearListScreenUiAction.GearListAction(it)) },
					modifier = modifier.padding(padding),
				)
		}
	}
}