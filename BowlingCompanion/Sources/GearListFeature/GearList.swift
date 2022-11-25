import GearDataProviderInterface
import ComposableArchitecture
import SharedModelsLibrary

public struct GearList: ReducerProtocol {
	public struct State: Equatable {
		public var gear: IdentifiedArrayOf<Gear>?
		public var error: ErrorContent?

		public init() {}
	}

	public enum Action: Equatable {
		case subscribeToGear
		case errorButtonTapped
		case gearResponse(TaskResult<[Gear]>)
		case swipeAction(Gear, SwipeAction)
	}

	public enum SwipeAction: Equatable {
		case delete
		case edit
	}

	public struct ErrorContent: Equatable {
		let title: String
		let message: String?
		let action: String

		static let loadError = Self(
			title: "Something went wrong!",
			message: "We couldn't load your data",
			action: "Try again"
		)

		static let deleteError = Self(
			title: "Something went wrong!",
			message: nil,
			action: "Reload"
		)
	}

	public init() {}

	@Dependency(\.gearDataProvider) var gearDataProvider

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .subscribeToGear:
				state.error = nil
				return .run { send in
					for try await gear in gearDataProvider.fetchGear(.init(ordering: .byRecentlyUsed)) {
						await send(.gearResponse(.success(gear)))
					}
				} catch: { error, send in
					await send(.gearResponse(.failure(error)))
				}

			case .errorButtonTapped:
				// TODO: handle error button tapped
				return .none

			case let .gearResponse(.success(gear)):
				state.gear = .init(uniqueElements: gear)
				return .none

			case .gearResponse(.failure):
				state.error = .loadError
				return .none

			case .swipeAction(_, .edit):
				// TODO: present gear editor
				return .none

			case .swipeAction(_, .delete):
				// TODO: present gear delete form
				return .none
			}
		}
	}
}
