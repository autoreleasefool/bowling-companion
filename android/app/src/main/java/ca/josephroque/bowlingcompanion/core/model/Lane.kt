package ca.josephroque.bowlingcompanion.core.model

import androidx.compose.runtime.Immutable
import java.util.UUID

@Immutable
data class LaneListItem(
	val id: UUID,
	val label: String,
	val position: LanePosition,
)

enum class LanePosition {
	LEFT_WALL,
	RIGHT_WALL,
	NO_WALL,
}