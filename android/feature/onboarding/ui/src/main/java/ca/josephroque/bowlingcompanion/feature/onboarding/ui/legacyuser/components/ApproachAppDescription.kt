package ca.josephroque.bowlingcompanion.feature.onboarding.ui.legacyuser.components

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.MutableTransitionState
import androidx.compose.animation.fadeIn
import androidx.compose.animation.slideInVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import ca.josephroque.bowlingcompanion.feature.onboarding.ui.R
import ca.josephroque.bowlingcompanion.feature.onboarding.ui.legacyuser.LegacyUserOnboardingUiAction
import ca.josephroque.bowlingcompanion.feature.onboarding.ui.legacyuser.LegacyUserOnboardingUiState

@Composable
fun ApproachAppDescription(
	state: LegacyUserOnboardingUiState,
	onAction: (LegacyUserOnboardingUiAction) -> Unit,
	modifier: Modifier = Modifier,
) {
	val visibleState = remember { MutableTransitionState(false) }

	LaunchedEffect(state) {
		when (state) {
			LegacyUserOnboardingUiState.Started, LegacyUserOnboardingUiState.ImportingData -> Unit
			is LegacyUserOnboardingUiState.ShowingApproachHeader -> visibleState.targetState = state.isDetailsVisible
		}
	}

	Description(
		visibleState = visibleState,
		onAction = onAction,
		modifier = modifier,
	)
}

@Composable
private fun Description(
	visibleState: MutableTransitionState<Boolean>,
	onAction: (LegacyUserOnboardingUiAction) -> Unit,
	modifier: Modifier = Modifier,
) {
	AnimatedVisibility(
		visibleState = visibleState,
		enter = slideInVertically(initialOffsetY = { it / 2 }) + fadeIn(),
		modifier = modifier,
	) {
		Box(
			modifier = Modifier
				.background(
					Brush.verticalGradient(
						0f to Color.Transparent,
						0.1f to Color.White,
						0.9f to Color.White,
						1f to Color.Transparent,
					)
				),
		) {
			Column(
				horizontalAlignment = Alignment.CenterHorizontally,
				modifier = Modifier
					.fillMaxWidth()
					.verticalScroll(rememberScrollState())
					.padding(horizontal = 16.dp, vertical = 32.dp),
			) {
				Text(
					text = stringResource(R.string.onboarding_legacy_user_title_is_taking_a_new),
					style = MaterialTheme.typography.titleMedium,
					fontStyle = FontStyle.Italic,
				)

				Text(
					text = stringResource(R.string.onboarding_legacy_user_title_approach),
					style = MaterialTheme.typography.headlineMedium,
					modifier = Modifier.padding(bottom = 16.dp),
				)

				Text(
					text = stringResource(R.string.onboarding_legacy_user_description_updated),
					style = MaterialTheme.typography.bodyMedium,
					fontWeight = FontWeight.Bold,
					modifier = Modifier.padding(bottom = 8.dp),
				)

				Text(
					text = stringResource(R.string.onboarding_legacy_user_description_wish),
					style = MaterialTheme.typography.bodyMedium,
					fontWeight = FontWeight.Bold,
					modifier = Modifier.padding(bottom = 16.dp),
				)

				Text(
					text = stringResource(R.string.onboarding_legacy_user_description_vancouver),
					style = MaterialTheme.typography.bodySmall,
					fontWeight = FontWeight.Bold,
					fontStyle = FontStyle.Italic,
					modifier = Modifier.padding(bottom = 16.dp),
				)

				Button(
					onClick = { onAction(LegacyUserOnboardingUiAction.GetStartedClicked) },
				) {
					Text(
						text = stringResource(R.string.onboarding_legacy_user_get_started),
						style = MaterialTheme.typography.bodyLarge,
					)
				}
			}
		}
	}
}