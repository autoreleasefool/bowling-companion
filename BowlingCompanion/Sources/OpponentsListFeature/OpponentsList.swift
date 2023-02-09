import ComposableArchitecture
import OpponentsDataProviderInterface
import OpponentEditorFeature
import PersistenceServiceInterface
import SharedModelsLibrary
import SharedModelsFetchableLibrary
import SortOrderLibrary
import ViewsLibrary

public struct OpponentsList: ReducerProtocol {
	public struct State: Equatable {
		public var opponents: IdentifiedArrayOf<Opponent>?
		public var sortOrder: SortOrder<Opponent.FetchRequest.Ordering>.State = .init(initialValue: .byRecentlyUsed)
		public var selection: Identified<Opponent.ID, Int>?
		public var error: ListErrorContent?
		public var opponentEditor: OpponentEditor.State?
		public var alert: AlertState<AlertAction>?

		public init() {}
	}

	public enum Action: Equatable {
		case observeOpponents
		case errorButtonTapped
		case swipeAction(Opponent, SwipeAction)
		case alert(AlertAction)
		case setNavigation(selection: Opponent.ID?)
		case setEditorFormSheet(isPresented: Bool)
		case opponentsResponse(TaskResult<[Opponent]>)
		case deleteOpponentResponse(TaskResult<Bool>)
		case opponentEditor(OpponentEditor.Action)
		case sortOrder(SortOrder<Opponent.FetchRequest.Ordering>.Action)
	}

	public enum SwipeAction: Equatable {
		case delete
		case edit
	}

	struct ObservationCancellable {}

	public init() {}

	@Dependency(\.continuousClock) var clock
	@Dependency(\.persistenceService) var persistenceService
	@Dependency(\.opponentsDataProvider) var opponentsDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Scope(state: \.sortOrder, action: /OpponentsList.Action.sortOrder) {
			SortOrder()
		}

		Reduce { state, action in
			switch action {
			case .observeOpponents:
				state.error = nil
				return .run { [ordering = state.sortOrder.ordering] send in
					for try await opponents in opponentsDataProvider.observeOpponents(.init(filter: nil, ordering: ordering)) {
						await send(.opponentsResponse(.success(opponents)))
					}
				} catch: { error, send in
					await send(.opponentsResponse(.failure(error)))
				}
				.cancellable(id: ObservationCancellable.self, cancelInFlight: true)

			case .errorButtonTapped:
				// TODO: handle error button tapped
				return .none

			case .setNavigation(selection: .some):
				// TODO: show opponent profile
				return .none

			case .setNavigation(selection: .none):
				// TODO: hide opponent profile
				return .none

			case let .opponentsResponse(.success(opponents)):
				state.opponents = .init(uniqueElements: opponents)
				return .none

			case .opponentsResponse(.failure):
				state.error = .loadError
				return .none

			case let .swipeAction(opponent, .edit):
				state.opponentEditor = .init(mode: .edit(opponent))
				return .none

			case let .swipeAction(opponent, .delete):
				state.alert = OpponentsList.alert(toDelete: opponent)
				return .none

			case .alert(.dismissed):
				state.alert = nil
				return .none

			case let .alert(.deleteButtonTapped(opponent)):
				return .task {
					return await .deleteOpponentResponse(TaskResult {
						try await persistenceService.deleteOpponent(opponent)
						return true
					})
				}

			case .deleteOpponentResponse(.success):
				return .none

			case .deleteOpponentResponse(.failure):
				state.error = .deleteError
				return .none

			case .setEditorFormSheet(isPresented: true):
				state.opponentEditor = .init(mode: .create)
				return .none

			case .setEditorFormSheet(isPresented: false):
				state.opponentEditor = nil
				return .none

			case let .opponentEditor(.delegate(delegateAction)):
				switch delegateAction {
				case .didFinishEditing:
					state.opponentEditor = nil
					return .none
				}

			case let .sortOrder(.delegate(delegateAction)):
				switch delegateAction {
				case .didTapOption:
					return .task { .observeOpponents }
				}

			case .sortOrder(.internal),
					.sortOrder(.view),
					.opponentEditor(.view),
					.opponentEditor(.internal),
					.opponentEditor(.binding):
				return .none
			}
		}
		.ifLet(\.opponentEditor, action: /OpponentsList.Action.opponentEditor) {
			OpponentEditor()
		}
	}
}
