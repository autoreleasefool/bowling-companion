package ca.josephroque.bowlingcompanion.feature.statisticsdetails

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import ca.josephroque.bowlingcompanion.core.designsystem.components.BackButton
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.ui.R

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun StatisticsDetailsTopBar(
	state: StatisticsDetailsUiState?,
	onAction: (StatisticsDetailsTopBarUiAction) -> Unit,
) {
	TopAppBar(
		title = {
			Text(
				text = stringResource(state?.chart?.chartContent?.chart?.titleResourceId ?: R.string.statistics_details_title),
				style = MaterialTheme.typography.titleLarge,
			)
		},
		navigationIcon = {
			BackButton(onClick = { onAction(StatisticsDetailsTopBarUiAction.BackClicked) })
		}
	)
}