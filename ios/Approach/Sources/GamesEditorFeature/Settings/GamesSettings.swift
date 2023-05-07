import ComposableArchitecture
import FeatureActionLibrary
import GamesRepositoryInterface
import ModelsLibrary

public struct GamesSettings: Reducer {
	public struct State: Equatable {
		public var game: Game.Edit

		init(game: Game.Edit) {
			self.game = game
		}
	}

	public enum Action: FeatureAction, Equatable {
		public enum ViewAction: Equatable {
			case didToggleLock
			case didToggleExclude
		}
		public enum DelegateAction: Equatable {
			case didFinish
		}
		public enum InternalAction: Equatable {}

		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
	}

	public var body: some Reducer<State, Action> {
		Reduce<State, Action> { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didToggleLock:
					state.game.locked.toggle()
					return .none

				case .didToggleExclude:
					state.game.excludeFromStatistics.toggle()
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case .never:
					return .none
				}

			case .delegate:
				return .none
			}
		}
	}
}
