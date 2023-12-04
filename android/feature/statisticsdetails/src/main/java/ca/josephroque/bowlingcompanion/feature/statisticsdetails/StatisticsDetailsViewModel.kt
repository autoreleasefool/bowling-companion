package ca.josephroque.bowlingcompanion.feature.statisticsdetails

import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.viewModelScope
import ca.josephroque.bowlingcompanion.core.common.viewmodel.ApproachViewModel
import ca.josephroque.bowlingcompanion.core.data.repository.StatisticsRepository
import ca.josephroque.bowlingcompanion.core.data.repository.UserDataRepository
import ca.josephroque.bowlingcompanion.core.statistics.StatisticID
import ca.josephroque.bowlingcompanion.core.statistics.TrackableFilter
import ca.josephroque.bowlingcompanion.core.statistics.charts.utils.getModel
import ca.josephroque.bowlingcompanion.core.statistics.statisticInstanceFromID
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.chart.StatisticsDetailsChartUiAction
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.chart.StatisticsDetailsChartUiState
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.list.StatisticsDetailsListUiAction
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.list.StatisticsDetailsListUiState
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.navigation.SOURCE_ID
import ca.josephroque.bowlingcompanion.feature.statisticsdetails.navigation.SOURCE_TYPE
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import java.util.UUID
import javax.inject.Inject

@HiltViewModel
class StatisticsDetailsViewModel @Inject constructor(
	savedStateHandle: SavedStateHandle,
	statisticsRepository: StatisticsRepository,
	private val userDataRepository: UserDataRepository,
): ApproachViewModel<StatisticsDetailsScreenEvent>() {
	private val _sourceType = savedStateHandle.get<String>(SOURCE_TYPE)
		?.let { SourceType.valueOf(it) } ?: SourceType.BOWLER

	private val _sourceId = savedStateHandle.get<String>(SOURCE_ID)
		?.let { UUID.fromString(it) } ?: UUID.randomUUID()

	private val _filter: MutableStateFlow<TrackableFilter> =
		MutableStateFlow(TrackableFilter(source = when (_sourceType) {
			SourceType.BOWLER -> TrackableFilter.Source.Bowler(_sourceId)
			SourceType.LEAGUE -> TrackableFilter.Source.League(_sourceId)
			SourceType.SERIES -> TrackableFilter.Source.Series(_sourceId)
			SourceType.GAME -> TrackableFilter.Source.Game(_sourceId)
		}))

	private val _statisticsList = _filter.map { statisticsRepository.getStatisticsList(it) }

	private val _highlightedEntry: MutableStateFlow<StatisticID?> = MutableStateFlow(null)

	private val _chartContent: Flow<StatisticsDetailsChartUiState.ChartContent?> = combine(
		_filter,
		_highlightedEntry,
	) { filter, highlightedEntry ->
		if (highlightedEntry == null) return@combine null
		val chart = statisticsRepository.getStatisticsChart(
			statistic = statisticInstanceFromID(highlightedEntry),
			filter = filter,
		)

		StatisticsDetailsChartUiState.ChartContent(
			chart = chart,
			model = chart.getModel(),
		)
	}

	private val _statisticsChartState: Flow<StatisticsDetailsChartUiState> = combine(
		_filter,
		_chartContent
	) { filter, chartContent ->
		if (chartContent == null)
			StatisticsDetailsChartUiState(
				aggregation = filter.aggregation,
				filterSource = filter.source,
				isLoadingNextChart = true,
				isFilterTooNarrow = false,
				chartContent = null,
			)
		else
			StatisticsDetailsChartUiState(
				aggregation = filter.aggregation,
				filterSource = filter.source,
				isLoadingNextChart = false,
				isFilterTooNarrow = false,
				chartContent = chartContent,
			)
	}

	private val _statisticsListState: Flow<StatisticsDetailsListUiState> = combine(
		_statisticsList,
		_highlightedEntry,
		userDataRepository.userData,
	) { statistics, highlightedEntry, userData ->
		StatisticsDetailsListUiState(
			statistics = statistics,
			highlightedEntry = highlightedEntry,
			isHidingZeroStatistics = !userData.isShowingZeroStatistics,
		)
	}

	val uiState: StateFlow<StatisticsDetailsScreenUiState> = combine(
		_statisticsListState,
		_statisticsChartState,
	) { statisticsList, statisticsChart ->
		StatisticsDetailsScreenUiState.Loaded(
			list = statisticsList,
			chart = statisticsChart,
		)
	}.stateIn(
		scope = viewModelScope,
		started = SharingStarted.WhileSubscribed(5_000),
		initialValue = StatisticsDetailsScreenUiState.Loading,
	)

	fun handleAction(action: StatisticsDetailsScreenUiAction) {
		when (action) {
			is StatisticsDetailsScreenUiAction.ListAction -> handleListAction(action.action)
			is StatisticsDetailsScreenUiAction.TopBarAction -> handleTopBarAction(action.action)
			is StatisticsDetailsScreenUiAction.ChartAction -> handleChartAction(action.action)
		}
	}

	private fun handleListAction(action: StatisticsDetailsListUiAction) {
		when (action) {
			is StatisticsDetailsListUiAction.StatisticClicked ->
				showStatisticChart(statistic = action.id)
			is StatisticsDetailsListUiAction.HidingZeroStatisticsToggled ->
				toggleHidingZeroStatistics(action.newValue)
		}
	}

	private fun handleTopBarAction(action: StatisticsDetailsTopBarUiAction) {
		when (action) {
			StatisticsDetailsTopBarUiAction.BackClicked -> sendEvent(StatisticsDetailsScreenEvent.Dismissed)
		}
	}

	private fun handleChartAction(action: StatisticsDetailsChartUiAction) {
		when (action) {
			is StatisticsDetailsChartUiAction.AggregationChanged ->
				toggleAggregation(action.newValue)
		}
	}

	private fun showStatisticChart(statistic: StatisticID) {
		_highlightedEntry.value = statistic
	}

	private fun toggleHidingZeroStatistics(newValue: Boolean?) {
		viewModelScope.launch {
			val currentValue = !userDataRepository.userData.first().isShowingZeroStatistics
			userDataRepository.setIsHidingZeroStatistics(newValue ?: !currentValue)
		}
	}

	private fun toggleAggregation(newValue: TrackableFilter.AggregationFilter) {
		_filter.value = _filter.value.copy(aggregation = newValue)
	}
}

enum class SourceType {
	BOWLER,
	LEAGUE,
	SERIES,
	GAME,
}

fun TrackableFilter.Source.sourceType(): SourceType = when (this) {
	is TrackableFilter.Source.Bowler -> SourceType.BOWLER
	is TrackableFilter.Source.League -> SourceType.LEAGUE
	is TrackableFilter.Source.Series -> SourceType.SERIES
	is TrackableFilter.Source.Game -> SourceType.GAME
}