import AnalyticsServiceInterface
import ComposableArchitecture
import ErrorsFeature
import FeatureActionLibrary
import NotificationsServiceInterface
import PreferenceServiceInterface
import StatisticsChartsLibrary
import StatisticsLibrary
import StatisticsRepositoryInterface
import StringsLibrary
import SwiftUI

public struct StatisticsDetails: Reducer {
	static let chartLoadingAnimationTime: TimeInterval = 0.5
	static let defaultSheetDetent: PresentationDetent = .fraction(0.25)

	public struct State: Equatable {
		public var listEntries: IdentifiedArrayOf<Statistics.ListEntryGroup> = []
		public var isLoadingNextChart = false
		public var chartContent: Statistics.ChartContent?

		public var filter: TrackableFilter
		public var sources: TrackableFilter.Sources?

		public var errors: Errors<ErrorID>.State = .init()

		@BindingState public var sheetDetent: PresentationDetent = StatisticsDetails.defaultSheetDetent
		public var willAdjustLaneLayoutAt: Date
		public var backdropSize: CGSize = .zero
		public var filtersSize: StatisticsFilterView.Size = .regular
		public var lastOrientation: UIDeviceOrientation?

		@PresentationState public var destination: Destination.State?

		public init(filter: TrackableFilter) {
			self.filter = filter

			@Dependency(\.date) var date
			self.willAdjustLaneLayoutAt = date()
		}
	}

	public enum Action: FeatureAction, Equatable {
		public enum ViewAction: BindableAction, Equatable {
			case didFirstAppear
			case didTapSourcePicker
			case didAdjustChartSize(backdropSize: CGSize, filtersSize: StatisticsFilterView.Size)
			case binding(BindingAction<State>)
		}
		public enum DelegateAction: Equatable {}
		public enum InternalAction: Equatable {
			case destination(PresentationAction<Destination.Action>)
			case charts(StatisticsDetailsCharts.Action)
			case errors(Errors<ErrorID>.Action)

			case didStartLoadingChart
			case adjustBackdrop
			case didLoadSources(TaskResult<TrackableFilter.Sources?>)
			case didLoadListEntries(TaskResult<[Statistics.ListEntryGroup]>)
			case didLoadChartContent(TaskResult<Statistics.ChartContent>)
			case orientationChange(UIDeviceOrientation)
		}

		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
	}

	public struct Destination: Reducer {
		public enum State: Equatable {
			case list(StatisticsDetailsList.State)
			case sourcePicker(StatisticsSourcePicker.State)
		}

		public enum Action: Equatable {
			case list(StatisticsDetailsList.Action)
			case sourcePicker(StatisticsSourcePicker.Action)
		}

		public var body: some ReducerOf<Self> {
			Scope(state: /State.list, action: /Action.list) {
				StatisticsDetailsList()
			}
			Scope(state: /State.sourcePicker, action: /Action.sourcePicker) {
				StatisticsSourcePicker()
			}
		}
	}

	public enum CancelID {
		case loadingStaticValues
		case loadingChartValues
	}

	public enum ErrorID: Hashable {
		case failedToLoadSources
		case failedToLoadList
		case failedToLoadChart
	}

	public init() {}

	@Dependency(\.continuousClock) var clock
	@Dependency(\.date) var date
	@Dependency(\.preferences) var preferences
	@Dependency(\.statistics) var statistics
	@Dependency(\.uiDeviceNotifications) var uiDevice

	public var body: some ReducerOf<Self> {
		BindingReducer(action: /Action.view)

		Scope(state: \.charts, action: /Action.internal..Action.InternalAction.charts) {
			StatisticsDetailsCharts()
		}

		Reduce<State, Action> { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didFirstAppear:
					return .merge(
						refreshStatistics(state: state),
						.run { send in
							for await orientation in uiDevice.orientationDidChange() {
								await send(.internal(.orientationChange(orientation)))
							}
						}
					)

				case .didTapSourcePicker:
					state.destination = .sourcePicker(.init(source: state.filter.source))
					return .none

				case let .didAdjustChartSize(backdropSize, filtersSize):
					state.backdropSize = backdropSize
					state.filtersSize = filtersSize
					return .none

				case .binding(\.$sheetDetent):
					return .run { send in
						try await clock.sleep(for: .milliseconds(25))
						await send(.internal(.adjustBackdrop))
					}

				case .binding:
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case .didStartLoadingChart:
					state.isLoadingNextChart = true
					return .none

				case let .didLoadSources(.success(sources)):
					state.sources = sources
					return .none

				case let .didLoadListEntries(.success(statistics)):
					state.listEntries = .init(uniqueElements: statistics)
					state.presentDestinationForLastOrientation()
					if state.chartContent == nil,
						 let firstGroup = state.listEntries.first,
						 let firstEntry = firstGroup.entries.first,
						 let firstStatistic = Statistics.type(of: firstEntry.id) {
						return loadChart(forStatistic: firstStatistic, withFilter: state.filter)
					} else {
						return .none
					}

				case let .didLoadChartContent(.success(chartContent)):
					state.chartContent = chartContent
					state.isLoadingNextChart = false
					return .none

				case let .didLoadSources(.failure(error)):
					return state.errors
						.enqueue(.failedToLoadSources, thrownError: error, toastMessage: Strings.Error.Toast.failedToLoad)
						.map { .internal(.errors($0)) }

				case let .didLoadListEntries(.failure(error)):
					return state.errors
						.enqueue(.failedToLoadList, thrownError: error, toastMessage: Strings.Error.Toast.failedToLoad)
						.map { .internal(.errors($0)) }

				case let .didLoadChartContent(.failure(error)):
					return state.errors
						.enqueue(.failedToLoadChart, thrownError: error, toastMessage: Strings.Error.Toast.failedToLoad)
						.map { .internal(.errors($0)) }

				case .adjustBackdrop:
					state.willAdjustLaneLayoutAt = date()
					return .none

				case let .orientationChange(orientation):
					state.lastOrientation = orientation
					state.presentDestinationForLastOrientation()
					return .run { send in
						try await clock.sleep(for: .milliseconds(300))
						await send(.internal(.adjustBackdrop))
					}

				case let .destination(.presented(.list(.delegate(delegateAction)))):
					switch delegateAction {
					case let .didRequestEntryDetails(id):
						guard let statistic = Statistics.type(of: id) else { return .none }
						state.sheetDetent = StatisticsDetails.defaultSheetDetent
						return loadChart(forStatistic: statistic, withFilter: state.filter)

					case .listRequiresReload:
						return refreshStatistics(state: state)
					}

				case let .destination(.presented(.sourcePicker(.delegate(delegateAction)))):
					switch delegateAction {
					case let .didChangeSource(source):
						state.filter.source = source
						return refreshStatistics(state: state)
					}

				case let .charts(.delegate(delegateAction)):
					switch delegateAction {
					case let .didChangeAggregation(aggregation):
						guard let statisticId = state.chartContent?.title,
									let statistic = Statistics.type(of: statisticId)
						else {
							return .none
						}
						state.filter.aggregation = aggregation
						return loadChart(forStatistic: statistic, withFilter: state.filter)
					}

				case .destination(.dismiss):
					return .run { [entries = state.listEntries] send in
						await send(.internal(.didLoadListEntries(.success(entries.elements))))
					}

				case let .errors(.delegate(delegateAction)):
					switch delegateAction {
					case .never:
						return .none
					}

				case .destination(.presented(.list(.internal))),
						.destination(.presented(.list(.view))),
						.destination(.presented(.sourcePicker(.internal))),
						.destination(.presented(.sourcePicker(.view))),
						.errors(.internal), .errors(.view),
						.charts(.internal), .charts(.view):
					return .none
				}

			case .delegate:
				return .none
			}
		}
		.ifLet(\.$destination, action: /Action.internal..Action.InternalAction.destination) {
			Destination()
		}

		AnalyticsReducer<State, Action> { _, action in
			switch action {
			case let .internal(.destination(.presented(.list(.delegate(.didRequestEntryDetails(id)))))):
				guard let statistic = Statistics.type(of: id) else { return nil }
				return Analytics.Statistic.Viewed(
					statisticName: statistic.title,
					countsH2AsH: preferences.bool(forKey: .statisticsCountH2AsH) ?? true,
					countsS2AsS: preferences.bool(forKey: .statisticsCountSplitWithBonusAsSplit) ?? true,
					hidesZeroStatistics: preferences.bool(forKey: .statisticsHideZeroStatistics) ?? true
				)
			default:
				return nil
			}
		}
	}

	private func refreshStatistics(state: State) -> Effect<Action> {
		.merge(
			.run { [filter = state.filter] send in
				await send(.internal(.didLoadListEntries(TaskResult {
					try await statistics.load(for: filter)
				})))
			},
			.run { [source = state.filter.source] send in
				await send(.internal(.didLoadSources(TaskResult {
					try await statistics.loadSources(source)
				})))
			}
		)
		.cancellable(id: CancelID.loadingStaticValues, cancelInFlight: true)
	}

	private func loadChart(forStatistic: Statistic.Type, withFilter: TrackableFilter) -> Effect<Action> {
		.concatenate(
			.run { send in await send(.internal(.didStartLoadingChart), animation: .easeInOut) },
			.run { send in
				let startTime = date()

				let result = await TaskResult { try await self.statistics.chart(statistic: forStatistic, filter: withFilter) }

				let timeSpent = date().timeIntervalSince(startTime)
				if timeSpent < Self.chartLoadingAnimationTime {
					try await clock.sleep(for: .milliseconds((Self.chartLoadingAnimationTime - timeSpent) * 1000))
				}

				await send(.internal(.didLoadChartContent(result)), animation: .easeInOut)
			}
		)
		.cancellable(id: CancelID.loadingChartValues, cancelInFlight: true)
	}
}

extension StatisticsDetails.State {
	var charts: StatisticsDetailsCharts.State {
		get {
			.init(
				aggregation: filter.aggregation,
				chartContent: chartContent,
				isLoadingNextChart: isLoadingNextChart
			)
		}
		// We aren't observing any values from this reducer, so we ignore the setter
		// swiftlint:disable:next unused_setter_value
		set {}
	}
}

extension StatisticsDetails.State {
	mutating func presentDestinationForLastOrientation() {
		switch lastOrientation {
		case .portrait, .portraitUpsideDown, .faceUp, .faceDown, .unknown, .none:
			destination = .list(.init(listEntries: listEntries))
		case .landscapeLeft, .landscapeRight:
			destination = nil
		@unknown default:
			destination = .list(.init(listEntries: listEntries))
		}
	}
}
