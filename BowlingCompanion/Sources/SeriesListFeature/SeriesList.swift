import ComposableArchitecture
import FeatureFlagsServiceInterface
import PersistenceServiceInterface
import SeriesDataProviderInterface
import SeriesEditorFeature
import SeriesSidebarFeature
import SharedModelsLibrary
import StringsLibrary
import ViewsLibrary

public struct SeriesList: ReducerProtocol {
	public struct State: Equatable {
		public var league: League
		public var series: IdentifiedArrayOf<Series>?
		public var error: ListErrorContent?
		public var selection: Identified<Series.ID, SeriesSidebar.State>?
		public var seriesEditor: SeriesEditor.State?
		public var newSeries: SeriesSidebar.State?
		public var alert: AlertState<AlertAction>?

		public init(league: League) {
			self.league = league
		}
	}

	public enum Action: Equatable {
		case observeSeries
		case seriesResponse(TaskResult<[Series]>)
		case setNavigation(selection: Series.ID?)
		case setEditorFormSheet(isPresented: Bool)
		case seriesCreateResponse(TaskResult<Series>)
		case seriesDeleteResponse(TaskResult<Series>)
		case errorButtonTapped
		case dismissNewSeries
		case swipeAction(Series, SwipeAction)
		case alert(AlertAction)

		case seriesSidebar(SeriesSidebar.Action)
		case seriesEditor(SeriesEditor.Action)
	}

	public enum SwipeAction: Equatable {
		case edit
		case delete
	}

	struct ObservationCancellable {}

	public init() {}

	@Dependency(\.uuid) var uuid
	@Dependency(\.date) var date
	@Dependency(\.seriesDataProvider) var seriesDataProvider
	@Dependency(\.persistenceService) var persistenceService
	@Dependency(\.featureFlags) var featureFlags: FeatureFlagsService

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .observeSeries:
				state.error = nil
				return .run { [league = state.league.id] send in
					for try await series in seriesDataProvider.observeSeries(.init(filter: .league(league), ordering: .byDate)) {
						await send(.seriesResponse(.success(series)))
					}
				} catch: { error, send in
					await send(.seriesResponse(.failure(error)))
				}
				.cancellable(id: ObservationCancellable.self, cancelInFlight: true)

			case .errorButtonTapped:
				// TODO: handle error button tapped
				return .none

			case let .seriesResponse(.success(series)):
				state.series = .init(uniqueElements: series)
				return .none

			case .seriesResponse(.failure):
				state.error = .loadError
				return .none

			case let .seriesCreateResponse(.success(series)):
				state.newSeries = .init(series: series)
				return .none

			case .seriesCreateResponse(.failure):
				state.error = .createError
				return .none

			case .dismissNewSeries:
				state.newSeries = nil
				return .none

			case let .setNavigation(selection: .some(id)):
				if let selection = state.series?[id: id] {
					state.selection = Identified(.init(series: selection), id: selection.id)
				}
				return .none

			case .setNavigation(selection: .none):
				state.selection = nil
				return .none

			case .setEditorFormSheet(isPresented: true):
				state.seriesEditor = .init(
					league: state.league,
					mode: .create,
					date: date(),
					hasAlleysEnabled: featureFlags.isEnabled(.alleys),
					hasLanesEnabled: featureFlags.isEnabled(.lanes)
				)
				return .none

			case .setEditorFormSheet(isPresented: false),
					.seriesEditor(.form(.didFinishSaving)),
					.seriesEditor(.form(.didFinishDeleting)),
					.seriesEditor(.form(.alert(.discardButtonTapped))):
				state.seriesEditor = nil
				return .none

			case let .swipeAction(series, .edit):
				state.seriesEditor = .init(
					league: state.league,
					mode: .edit(series),
					date: date(),
					hasAlleysEnabled: featureFlags.isEnabled(.alleys),
					hasLanesEnabled: featureFlags.isEnabled(.lanes)
				)
				return .none

			case let .swipeAction(series, .delete):
				state.alert = SeriesList.alert(toDelete: series)
				return .none

			case .alert(.dismissed):
				state.alert = nil
				return .none

			case let .alert(.deleteButtonTapped(series)):
				return .task {
					return await .seriesDeleteResponse(TaskResult {
						try await persistenceService.deleteSeries(series)
						return series
					})
				}

			case .seriesDeleteResponse(.failure):
				state.error = .deleteError
				return .none

			case .seriesSidebar, .seriesEditor, .seriesDeleteResponse(.success):
				return .none
			}
		}
		.ifLet(\.selection, action: /SeriesList.Action.seriesSidebar) {
			Scope(state: \Identified<Series.ID, SeriesSidebar.State>.value, action: /.self) {
				SeriesSidebar()
			}
		}
		.ifLet(\.newSeries, action: /SeriesList.Action.seriesSidebar) {
			SeriesSidebar()
		}
		.ifLet(\.seriesEditor, action: /SeriesList.Action.seriesEditor) {
			SeriesEditor()
		}
	}
}

extension ListErrorContent {
	static let createError = Self(
		title: Strings.Series.Error.FailedToCreate.title,
		message: Strings.Series.Error.FailedToCreate.message,
		action: Strings.Action.tryAgain
	)
}
