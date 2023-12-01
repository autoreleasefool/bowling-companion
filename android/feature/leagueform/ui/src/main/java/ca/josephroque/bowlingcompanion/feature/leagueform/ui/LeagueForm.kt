package ca.josephroque.bowlingcompanion.feature.leagueform.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import ca.josephroque.bowlingcompanion.core.designsystem.components.ArchiveDialog
import ca.josephroque.bowlingcompanion.core.designsystem.R as RCoreDesign
import ca.josephroque.bowlingcompanion.core.designsystem.components.form.FormRadioGroup
import ca.josephroque.bowlingcompanion.core.designsystem.components.form.FormSection
import ca.josephroque.bowlingcompanion.core.designsystem.components.form.FormSwitch
import ca.josephroque.bowlingcompanion.core.model.ExcludeFromStatistics
import ca.josephroque.bowlingcompanion.core.model.LeagueRecurrence

@Composable
fun LeagueForm(
	state: LeagueFormUiState,
	onAction: (LeagueFormUiAction) -> Unit,
	modifier: Modifier = Modifier,
) {
	if (state.isShowingArchiveDialog) {
		ArchiveDialog(
			itemName = state.name,
			onArchive = { onAction(LeagueFormUiAction.ConfirmArchiveClicked) },
			onDismiss = { onAction(LeagueFormUiAction.DismissArchiveClicked) },
		)
	}

	Column(
		modifier = modifier
			.verticalScroll(rememberScrollState())
			.fillMaxSize(),
	) {
		FormSection(titleResourceId = R.string.league_form_details_title) {
			LeagueNameField(
				name = state.name,
				onNameChanged = { onAction(LeagueFormUiAction.NameChanged(it)) },
				errorId = state.nameErrorId,
			)
		}

		state.recurrence?.let {
			Divider()
			FormSection(Modifier.padding(top = 16.dp)) {
				RecurrencePicker(
					recurrence = it,
					onRecurrenceChanged = { onAction(LeagueFormUiAction.RecurrenceChanged(it)) }
				)
			}
		}

		if (state.recurrence != null || state.gamesPerSeries != null) {
			Divider()

			when (state.recurrence) {
				LeagueRecurrence.ONCE, null -> Unit
				LeagueRecurrence.REPEATING -> state.gamesPerSeries?.let {
					FormSection(Modifier.padding(top = 16.dp)) {
						GamesPerSeriesPicker(
							gamesPerSeries = it,
							onGamesPerSeriesChanged = { onAction(LeagueFormUiAction.GamesPerSeriesChanged(it)) },
						)
					}
				}
			}

			when (state.gamesPerSeries) {
				GamesPerSeries.DYNAMIC, null -> Unit
				GamesPerSeries.STATIC -> state.numberOfGames?.let {
					FormSection(
						titleResourceId = when (state.recurrence) {
							LeagueRecurrence.ONCE -> R.string.league_form_property_number_of_games
							LeagueRecurrence.REPEATING, null -> null
						},
						modifier = Modifier.padding(vertical = 16.dp)
					) {
						NumberOfGamesSlider(
							numberOfGames = it,
							onNumberOfGamesChanged = { onAction(LeagueFormUiAction.NumberOfGamesChanged(it)) },
						)
					}
				}
			}
		}

		Divider()
		IncludeAdditionalPinFallSwitch(
			includeAdditionalPinFall = state.includeAdditionalPinFall,
			onIncludeAdditionalPinFallChanged = { onAction(LeagueFormUiAction.IncludeAdditionalPinFallChanged(it)) },
		)

		when (state.includeAdditionalPinFall) {
			IncludeAdditionalPinFall.INCLUDE -> {
				Column(
					verticalArrangement = Arrangement.spacedBy(8.dp),
					modifier = Modifier
						.fillMaxWidth()
						.padding(bottom = 16.dp),
				) {
					AdditionalPinFallField(
						additionalPinFall = state.additionalPinFall,
						onAdditionalPinFallChanged = { onAction(LeagueFormUiAction.AdditionalPinFallChanged(it)) },
					)

					AdditionalGamesField(
						additionalGames = state.additionalGames,
						onAdditionalGamesChanged = { onAction(LeagueFormUiAction.AdditionalGamesChanged(it)) },
					)
				}
			}
			IncludeAdditionalPinFall.NONE -> Unit
		}

		Divider()
		FormSection(Modifier.padding(top = 16.dp)) {
			ExcludeFromStatisticsPicker(
				excludeFromStatistics = state.excludeFromStatistics,
				onExcludeFromStatisticsChanged = { onAction(LeagueFormUiAction.ExcludeFromStatisticsChanged(it)) },
			)
		}
	}
}

@Composable
private fun LeagueNameField(
	name: String,
	onNameChanged: (String) -> Unit,
	errorId: Int?
) {
	OutlinedTextField(
		value = name,
		onValueChange = onNameChanged,
		label = { Text(stringResource(R.string.league_form_property_name)) },
		singleLine = true,
		isError = errorId != null,
		supportingText = {
			errorId?.let {
				Text(
					text = stringResource(it),
					color = MaterialTheme.colorScheme.error,
					modifier = Modifier.fillMaxWidth(),
				)
			}
		},
		trailingIcon = {
			if (errorId != null) {
				Icon(
					Icons.Default.Warning,
					tint = MaterialTheme.colorScheme.error,
					contentDescription = null
				)
			}
		},
		modifier = Modifier
			.fillMaxWidth()
			.padding(horizontal = 16.dp)
	)
}

@Composable
private fun RecurrencePicker(
	recurrence: LeagueRecurrence,
	onRecurrenceChanged: (LeagueRecurrence) -> Unit,
) {
	FormRadioGroup(
		title = stringResource(R.string.league_form_property_repeat),
		subtitle = stringResource(
			R.string.league_form_property_repeat_footer,
			stringResource(R.string.league_form_property_repeat_repeats),
			stringResource(R.string.league_form_property_repeat_never),
		),
		options = LeagueRecurrence.values(),
		selected = recurrence,
		titleForOption = {
			when (it) {
				LeagueRecurrence.REPEATING -> stringResource(R.string.league_form_property_repeat_repeats)
				LeagueRecurrence.ONCE -> stringResource(R.string.league_form_property_repeat_never)
				null -> ""
			}
		},
		onOptionSelected = {
			it ?: return@FormRadioGroup
			onRecurrenceChanged(it)
		}
	)
}

@Composable
private fun ExcludeFromStatisticsPicker(
	excludeFromStatistics: ExcludeFromStatistics,
	onExcludeFromStatisticsChanged: (ExcludeFromStatistics) -> Unit,
) {
	FormRadioGroup(
		title = stringResource(R.string.league_form_property_exclude),
		subtitle = stringResource(R.string.league_form_property_exclude_footer),
		options = ExcludeFromStatistics.values(),
		selected = excludeFromStatistics,
		titleForOption = {
			when (it) {
				ExcludeFromStatistics.INCLUDE -> stringResource(R.string.league_form_property_exclude_include)
				ExcludeFromStatistics.EXCLUDE -> stringResource(R.string.league_form_property_exclude_exclude)
				null -> ""
			}
		},
		onOptionSelected = {
			it ?: return@FormRadioGroup
			onExcludeFromStatisticsChanged(it)
		}
	)
}

@Composable
private fun GamesPerSeriesPicker(
	gamesPerSeries: GamesPerSeries,
	onGamesPerSeriesChanged: (GamesPerSeries) -> Unit,
) {
	FormRadioGroup(
		title = stringResource(R.string.league_form_property_number_of_games),
		subtitle = stringResource(
			R.string.league_form_property_number_of_games_footer,
			stringResource(R.string.league_form_property_number_of_games_constant),
			stringResource(R.string.league_form_property_number_of_games_always_ask),
		),
		options = GamesPerSeries.values(),
		selected = gamesPerSeries,
		titleForOption = {
			when (it) {
				GamesPerSeries.STATIC -> stringResource(R.string.league_form_property_number_of_games_constant)
				GamesPerSeries.DYNAMIC -> stringResource(R.string.league_form_property_number_of_games_always_ask)
				null -> ""
			}
		},
		onOptionSelected = {
			it ?: return@FormRadioGroup
			onGamesPerSeriesChanged(it)
		}
	)
}

@Composable
private fun NumberOfGamesSlider(
	numberOfGames: Int,
	onNumberOfGamesChanged: (Int) -> Unit,
) {
	Row(
		verticalAlignment = Alignment.CenterVertically,
		horizontalArrangement = Arrangement.spacedBy(8.dp),
		modifier = Modifier
			.fillMaxWidth()
			.padding(horizontal = 16.dp),
	) {
		OutlinedTextField(
			value = numberOfGames.toString(),
			onValueChange = {
				val intValue = it.toIntOrNull() ?: 1
				onNumberOfGamesChanged(intValue)
			},
			label = { Text(stringResource(R.string.league_form_property_number_of_games)) },
			singleLine = true,
			modifier = Modifier.weight(1f),
		)

		Row(
			verticalAlignment = Alignment.CenterVertically,
		) {
			IconButton(onClick = { onNumberOfGamesChanged(numberOfGames - 1) }) {
				Icon(
					painter = painterResource(RCoreDesign.drawable.ic_minus_circle),
					contentDescription = stringResource(RCoreDesign.string.cd_decrement),
					tint = MaterialTheme.colorScheme.onSurface,
				)
			}

			IconButton(onClick = { onNumberOfGamesChanged(numberOfGames + 1) }) {
				Icon(
					painter = painterResource(RCoreDesign.drawable.ic_add_circle),
					contentDescription = stringResource(RCoreDesign.string.cd_increment),
					tint = MaterialTheme.colorScheme.onSurface,
				)
			}
		}
	}
}

@Composable
private fun IncludeAdditionalPinFallSwitch(
	includeAdditionalPinFall: IncludeAdditionalPinFall,
	onIncludeAdditionalPinFallChanged: (IncludeAdditionalPinFall) -> Unit,
) {
	FormSwitch(
		titleResourceId = R.string.league_form_property_pinfall,
		isChecked = includeAdditionalPinFall == IncludeAdditionalPinFall.INCLUDE,
		onCheckChanged = {
			onIncludeAdditionalPinFallChanged(if (it) IncludeAdditionalPinFall.INCLUDE else IncludeAdditionalPinFall.NONE)
		},
		modifier = Modifier
			.fillMaxWidth()
			.padding(horizontal = 16.dp)
	)
}

@Composable
private fun AdditionalPinFallField(
	additionalPinFall: Int,
	onAdditionalPinFallChanged: (Int) -> Unit,
) {
	OutlinedTextField(
		value = additionalPinFall.toString(),
		onValueChange = {
			val intValue = it.toIntOrNull() ?: 0
			onAdditionalPinFallChanged(intValue)
		},
		label = { Text(stringResource(R.string.league_form_property_pinfall_additional_pinfall)) },
		singleLine = true,
		modifier = Modifier
			.fillMaxWidth()
			.padding(horizontal = 16.dp)
	)
}

@Composable
private fun AdditionalGamesField(
	additionalGames: Int,
	onAdditionalGamesChanged: (Int) -> Unit,
) {
	OutlinedTextField(
		value = additionalGames.toString(),
		onValueChange = {
			val intValue = it.toIntOrNull() ?: 0
			onAdditionalGamesChanged(intValue)
		},
		label = { Text(stringResource(R.string.league_form_property_pinfall_additional_games)) },
		singleLine = true,
		modifier = Modifier
			.fillMaxWidth()
			.padding(horizontal = 16.dp)
	)
}