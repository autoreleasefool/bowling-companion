package ca.josephroque.bowlingcompanion.core.database.dao

import androidx.room.Dao
import androidx.room.Query
import androidx.room.Transaction
import ca.josephroque.bowlingcompanion.core.database.model.GameWithFrames
import kotlinx.coroutines.flow.Flow
import java.util.UUID

@Dao
interface FrameDao {
	@Transaction
	@Query(value = "SELECT * FROM games WHERE id = :gameId")
	abstract fun getGameFrames(gameId: UUID): Flow<GameWithFrames>
}