package ca.josephroque.bowlingcompanion.ui

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.navigation.NavDestination
import androidx.navigation.NavDestination.Companion.hierarchy
import ca.josephroque.bowlingcompanion.core.components.ApproachNavigationBarItem
import ca.josephroque.bowlingcompanion.navigation.ApproachNavHost
import ca.josephroque.bowlingcompanion.navigation.TopLevelDestination

@Composable
fun ApproachApp(
	appState: ApproachAppState = rememberApproachAppState()
) {
	Scaffold(
		bottomBar = {
			ApproachBottomBar(
				destinations = appState.topLevelDestinations,
				onNavigateToDestination = appState::navigateToTopLevelDestination,
				currentDestination = appState.currentDestination
			)
		}
	) { padding ->
		Row(
			Modifier
				.fillMaxSize()
				.padding(padding)
		) {
			ApproachNavHost(appState = appState)
		}
	}
}

@Composable
private fun ApproachBottomBar(
	destinations: List<TopLevelDestination>,
	onNavigateToDestination: (TopLevelDestination) -> Unit,
	currentDestination: NavDestination?
) {
	NavigationBar {
		destinations.forEach { destination ->
			val isSelected = currentDestination.isTopLevelDestinationInHierarchy(destination)

			ApproachNavigationBarItem(
				isSelected = isSelected,
				onClick = { onNavigateToDestination(destination) },
				icon = {
					Icon(imageVector = destination.unselectedIcon, contentDescription = null)
				},
				selectedIcon = {
					Icon(imageVector = destination.selectedIcon, contentDescription = null)
				},
				label = { Text(stringResource(destination.iconTextId)) }
			)
		}
	}
}

private fun NavDestination?.isTopLevelDestinationInHierarchy(destination: TopLevelDestination) =
	this?.hierarchy?.any {
		it.route?.contains(destination.name, true) ?: false
	} ?: false