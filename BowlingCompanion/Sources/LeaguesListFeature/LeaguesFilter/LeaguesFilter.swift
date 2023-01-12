import ComposableArchitecture
import LeaguesDataProviderInterface
import SharedModelsLibrary

public struct LeaguesFilter: ReducerProtocol {
	public struct State: Equatable {
		@BindableState public var recurrence: League.Recurrence?

		public init() {}
	}

	public enum Action: BindableAction, Equatable {
		case binding(BindingAction<State>)
		case applyButtonTapped
		case clearFiltersButtonTapped
	}

	public init() {}

	public var body: some ReducerProtocol<State, Action> {
		BindingReducer()

		Reduce { state, action in
			switch action {
			case .clearFiltersButtonTapped:
				state = .init()
				return .task { .applyButtonTapped }

			case .applyButtonTapped, .binding:
				return .none
			}
		}
	}
}

extension LeaguesFilter.State {
	public var hasFilters: Bool {
		recurrence != nil
	}

	public func filter(withBowler: Bowler.ID) -> League.FetchRequest.Filter {
		.properties(withBowler, recurrence: recurrence)
	}
}
