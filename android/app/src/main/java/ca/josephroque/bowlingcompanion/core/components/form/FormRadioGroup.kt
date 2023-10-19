package ca.josephroque.bowlingcompanion.core.components.form

import androidx.annotation.StringRes
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.selection.selectable
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.unit.dp

@Composable
fun <T>FormRadioGroup(
	@StringRes titleResourceId: Int,
	options: Array<T>,
	selected: T?,
	titleForOption: @Composable (T?) -> String,
	onOptionSelected: (T?) -> Unit,
	modifier: Modifier = Modifier,
	@StringRes subtitleResourceId: Int? = null,
) {
	FormRadioGroup(
		title = stringResource(titleResourceId),
		options = options,
		selected = selected,
		titleForOption = titleForOption,
		onOptionSelected = onOptionSelected,
		modifier = modifier,
		subtitle = subtitleResourceId?.let { stringResource(it) },
	)
}

@Composable
fun <T>FormRadioGroup(
	title: String,
	options: Array<T>,
	selected: T?,
	titleForOption: @Composable (T?) -> String,
	onOptionSelected: (T?) -> Unit,
	modifier: Modifier = Modifier,
	allowNullableSelection: Boolean = false,
	subtitle: String? = null,
) {
	Column(modifier = modifier) {
		Text(
			text = title,
			style = MaterialTheme.typography.titleMedium,
			modifier = Modifier.padding(horizontal = 16.dp),
		)

		subtitle?.let {
			Text(
				text = subtitle,
				style = MaterialTheme.typography.bodySmall,
				modifier = Modifier
					.padding(horizontal = 16.dp, vertical = 8.dp),
			)
		}
		
		if (allowNullableSelection) {
			FormRadioButton(
				isSelected = selected == null,
				title = titleForOption(null),
				onClick = { onOptionSelected(null) },
			)
		}

		options.forEach {
			val isSelected = it == selected

			FormRadioButton(
				isSelected = isSelected,
				title = titleForOption(it),
				onClick = { onOptionSelected(it) },
			)
		}
	}
}

@Composable
private fun FormRadioButton(
	isSelected: Boolean,
	title: String,
	onClick: () -> Unit,
) {
	Surface(
		color = if (isSelected) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface,
		modifier = Modifier
			.selectable(
				selected = isSelected,
				onClick = onClick,
				role = Role.RadioButton,
			)
	) {
		Row(
			verticalAlignment = Alignment.CenterVertically,
			modifier = Modifier
				.fillMaxWidth()
				.padding(16.dp),
		) {
			Text(
				text = title,
				style = MaterialTheme.typography.bodyLarge,
				modifier = Modifier.weight(1f),
			)

			Box(modifier = Modifier.padding(8.dp)) {
				RadioButton(selected = isSelected, onClick = null)
			}
		}
	}
}