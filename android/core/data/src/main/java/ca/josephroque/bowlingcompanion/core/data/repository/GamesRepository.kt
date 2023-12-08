package ca.josephroque.bowlingcompanion.core.data.repository

import ca.josephroque.bowlingcompanion.core.model.ArchivedGame
import ca.josephroque.bowlingcompanion.core.model.GameEdit
import ca.josephroque.bowlingcompanion.core.model.GameListItem
import ca.josephroque.bowlingcompanion.core.model.GameScoringMethod
import kotlinx.coroutines.flow.Flow
import java.util.UUID

interface GamesRepository {
	fun getArchivedGames(): Flow<List<ArchivedGame>>

	fun getGameDetails(gameId: UUID): Flow<GameEdit>
	fun getGamesList(seriesId: UUID): Flow<List<GameListItem>>
	fun getGameIndex(gameId: UUID): Flow<Int>

	suspend fun setGameScoringMethod(gameId: UUID, scoringMethod: GameScoringMethod, score: Int)

	suspend fun archiveGame(gameId: UUID)
	suspend fun unarchiveGame(gameId: UUID)
}