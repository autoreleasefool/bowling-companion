package ca.josephroque.bowlingcompanion.core.data.repository

import ca.josephroque.bowlingcompanion.core.model.TeamCreate
import ca.josephroque.bowlingcompanion.core.model.TeamListItem
import ca.josephroque.bowlingcompanion.core.model.TeamMemberListItem
import ca.josephroque.bowlingcompanion.core.model.TeamSortOrder
import ca.josephroque.bowlingcompanion.core.model.TeamUpdate
import java.util.UUID
import kotlinx.coroutines.flow.Flow

interface TeamsRepository {
	fun getTeamList(sortOrder: TeamSortOrder): Flow<List<TeamListItem>>
	fun getTeamMembers(ids: List<UUID>): Flow<List<TeamMemberListItem>>

	fun getTeamUpdate(id: UUID): Flow<TeamUpdate>

	suspend fun insertTeam(team: TeamCreate)
	suspend fun updateTeam(team: TeamUpdate)
	suspend fun deleteTeam(id: UUID)
}
