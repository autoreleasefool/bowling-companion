package ca.josephroque.bowlingcompanion.feature.gameseditor.navigation

import android.net.Uri
import androidx.navigation.NavController
import androidx.navigation.NavGraphBuilder
import androidx.navigation.NavType
import androidx.navigation.compose.composable
import androidx.navigation.navArgument
import ca.josephroque.bowlingcompanion.core.common.navigation.NavResultCallback
import ca.josephroque.bowlingcompanion.core.statistics.TrackableFilter
import ca.josephroque.bowlingcompanion.feature.gameseditor.GamesEditorRoute
import ca.josephroque.bowlingcompanion.feature.gameseditor.GamesEditorScreenEvent
import java.util.UUID

const val EDITOR_SERIES_ID = "seriesid"
const val INITIAL_GAME_ID = "gameid"
const val gamesEditorNavigationRoute = "edit_games/{$EDITOR_SERIES_ID}/{$INITIAL_GAME_ID}"

fun NavController.navigateToGamesEditor(seriesId: UUID, initialGameId: UUID) {
	val seriesIdEncoded = Uri.encode(seriesId.toString())
	val gameIdEncoded = Uri.encode(initialGameId.toString())
	this.navigate("edit_games/$seriesIdEncoded/$gameIdEncoded")
}

fun NavGraphBuilder.gamesEditorScreen(
	onBackPressed: () -> Unit,
	onEditMatchPlay: (UUID) -> Unit,
	onEditGear: (Set<UUID>, NavResultCallback<Set<UUID>>) -> Unit,
	onEditAlley: (UUID?, NavResultCallback<Set<UUID>>) -> Unit,
	onEditLanes: (UUID, Set<UUID>, NavResultCallback<Set<UUID>>) -> Unit,
	onShowGamesSettings: (UUID, UUID, NavResultCallback<UUID>) -> Unit,
	onEditRolledBall: (UUID?, NavResultCallback<Set<UUID>>) -> Unit,
	onShowStatistics: (TrackableFilter) -> Unit,
) {
	composable(
		route = gamesEditorNavigationRoute,
		arguments = listOf(
			navArgument(EDITOR_SERIES_ID) { type = NavType.StringType },
			navArgument(INITIAL_GAME_ID) { type = NavType.StringType },
		),
	) {
		GamesEditorRoute(
			onBackPressed = onBackPressed,
			onEditMatchPlay = onEditMatchPlay,
			onEditGear = onEditGear,
			onEditAlley = onEditAlley,
			onEditLanes = onEditLanes,
			onShowGamesSettings = onShowGamesSettings,
			onEditRolledBall = onEditRolledBall,
			onShowStatistics = onShowStatistics,
		)
	}
}