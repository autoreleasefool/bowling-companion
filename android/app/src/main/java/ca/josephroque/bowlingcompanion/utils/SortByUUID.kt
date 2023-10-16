package ca.josephroque.bowlingcompanion.utils

import java.util.UUID

interface SortableByUUID {
	val id: UUID
}

fun <T: SortableByUUID> List<T>.sortByUUIDs(ids: List<String>): List<T> {
	if (ids.isEmpty()) {
		return this
	}

	val idIndices = buildMap<String, Int> {
		ids.forEachIndexed { index, id ->
			put(id, index)
		}
	}

	return this.sortedBy {
		idIndices[it.id.toString()]
	}
}