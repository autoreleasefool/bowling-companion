package ca.josephroque.bowlingcompanion.feature.settings.ui.developer

import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarScrollBehavior
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import ca.josephroque.bowlingcompanion.core.designsystem.components.BackButton
import ca.josephroque.bowlingcompanion.feature.settings.ui.R

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DeveloperSettingsTopBar(
	onAction: (DeveloperSettingsUiAction) -> Unit,
	scrollBehavior: TopAppBarScrollBehavior,
) {
	TopAppBar(
		scrollBehavior = scrollBehavior,
		title = {
			Text(
				text = stringResource(R.string.developer_settings_title),
				style = MaterialTheme.typography.titleLarge,
			)
		},
		navigationIcon = {
			BackButton(onClick = { onAction(DeveloperSettingsUiAction.BackClicked) })
		}
	)
}