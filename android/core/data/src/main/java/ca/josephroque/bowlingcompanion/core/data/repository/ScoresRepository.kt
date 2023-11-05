package ca.josephroque.bowlingcompanion.core.data.repository

import ca.josephroque.bowlingcompanion.core.model.ScoringGame
import kotlinx.coroutines.flow.Flow
import java.util.UUID

interface ScoresRepository {
	fun getScore(gameId: UUID): Flow<ScoringGame>
}