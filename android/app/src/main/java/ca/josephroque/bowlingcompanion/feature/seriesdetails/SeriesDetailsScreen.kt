package ca.josephroque.bowlingcompanion.feature.seriesdetails

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import ca.josephroque.bowlingcompanion.core.designsystem.components.BackButton
import ca.josephroque.bowlingcompanion.feature.gameslist.GamesListUiState
import ca.josephroque.bowlingcompanion.feature.gameslist.gamesList
import ca.josephroque.bowlingcompanion.feature.seriesdetails.ui.SeriesDetailsHeader
import ca.josephroque.bowlingcompanion.utils.format
import java.util.UUID

@Composable
internal fun SeriesDetailsRoute(
	onBackPressed: () -> Unit,
	onEditGame: (UUID, UUID) -> Unit,
	modifier: Modifier = Modifier,
	viewModel: SeriesDetailsViewModel = hiltViewModel(),
) {
	val seriesDetailsState by viewModel.seriesDetailsState.collectAsStateWithLifecycle()
	val gamesListState by viewModel.gamesListState.collectAsStateWithLifecycle()

	SeriesDetailsScreen(
		seriesDetailsState = seriesDetailsState,
		gamesListState = gamesListState,
		onBackPressed = onBackPressed,
		onGameClick = {
			when (val state = seriesDetailsState) {
				is SeriesDetailsUiState.Success -> onEditGame(state.details.id, it)
				else -> Unit
			}
		},
		modifier = modifier,
	)
}

@Composable
internal fun SeriesDetailsScreen(
	seriesDetailsState: SeriesDetailsUiState,
	gamesListState: GamesListUiState,
	onBackPressed: () -> Unit,
	onGameClick: (UUID) -> Unit,
	modifier: Modifier = Modifier,
) {
	Scaffold(
		topBar = {
			SeriesDetailsTopBar(
				seriesDetailsState = seriesDetailsState,
				onBackPressed = onBackPressed,
			)
		}
	) { padding ->
		LazyColumn(
			modifier = modifier
				.fillMaxSize()
				.padding(padding),
		) {
			item {
				when (seriesDetailsState) {
					SeriesDetailsUiState.Loading -> Unit
					is SeriesDetailsUiState.Success -> SeriesDetailsHeader(
						numberOfGames = seriesDetailsState.details.numberOfGames,
						seriesTotal = seriesDetailsState.details.total,
						scores = seriesDetailsState.scores,
						modifier = Modifier
							.padding(horizontal = 16.dp)
							.padding(bottom = 16.dp),
					)
				}
			}

			gamesList(
				gamesListState = gamesListState,
				onGameClick = onGameClick,
			)
		}
	}
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun SeriesDetailsTopBar(
	onBackPressed: () -> Unit,
	seriesDetailsState: SeriesDetailsUiState,
) {
	TopAppBar(
		colors = TopAppBarDefaults.topAppBarColors(),
		title = { Title(seriesDetailsState) },
		navigationIcon = { BackButton(onClick = onBackPressed) },
	)
}

@Composable
private fun Title(seriesDetailsState: SeriesDetailsUiState) {
	Text(
		text = when (seriesDetailsState) {
			SeriesDetailsUiState.Loading -> ""
			is SeriesDetailsUiState.Success -> seriesDetailsState.details
				.date.format("MMMM d, yyyy")
		},
		maxLines = 1,
		overflow = TextOverflow.Ellipsis,
		style = MaterialTheme.typography.titleLarge,
	)
}