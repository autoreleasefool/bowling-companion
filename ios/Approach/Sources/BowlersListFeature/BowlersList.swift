import BowlersDataProviderInterface
import BowlerEditorFeature
import ComposableArchitecture
import FeatureActionLibrary
import FeatureFlagsLibrary
import FeatureFlagsServiceInterface
import LeaguesListFeature
import PersistenceServiceInterface
import RecentlyUsedServiceInterface
import ResourceListLibrary
import SharedModelsLibrary
import SharedModelsFetchableLibrary
import SortOrderLibrary
import StringsLibrary
import ViewsLibrary

extension Bowler: ResourceListItem {}

public struct BowlersList: ReducerProtocol {
	public struct State: Equatable {
		public var list: ResourceList<Bowler, Bowler.FetchRequest>.State
		public var editor: BowlerEditor.State?
		public var sortOrder: SortOrder<Bowler.FetchRequest.Ordering>.State = .init(initialValue: .byRecentlyUsed)

		public var selection: Identified<Bowler.ID, LeaguesList.State>?

		public let hasAvatarsEnabled: Bool

		public init() {
			self.list = .init(
				features: [
					.add,
					.swipeToEdit,
					.swipeToDelete(
						onDelete: .init {
							@Dependency(\.persistenceService) var persistenceService: PersistenceService
							try await persistenceService.deleteBowler($0)
						}
					),
				],
				query: .init(filter: nil, ordering: sortOrder.ordering),
				listTitle: Strings.Bowler.List.title,
				emptyContent: .init(
					image: .emptyBowlers,
					title: Strings.Bowler.Error.Empty.title,
					message: Strings.Bowler.Error.Empty.message,
					action: Strings.Bowler.List.add
				)
			)

			@Dependency(\.featureFlags) var featureFlags: FeatureFlagsService
			self.hasAvatarsEnabled = featureFlags.isEnabled(.avatars)
		}
	}

	public enum Action: FeatureAction, Equatable {
		public enum ViewAction: Equatable {
			case didTapConfigureStatisticsButton
			case setNavigation(selection: Bowler.ID?)
			case setEditorSheet(isPresented: Bool)
		}

		public enum DelegateAction: Equatable {}

		public enum InternalAction: Equatable {
			case list(ResourceList<Bowler, Bowler.FetchRequest>.Action)
			case editor(BowlerEditor.Action)
			case leagues(LeaguesList.Action)
			case sortOrder(SortOrder<Bowler.FetchRequest.Ordering>.Action)
		}

		case view(ViewAction)
		case `internal`(InternalAction)
		case delegate(DelegateAction)
	}

	public init() {}

	@Dependency(\.continuousClock) var clock
	@Dependency(\.bowlersDataProvider) var bowlersDataProvider
	@Dependency(\.recentlyUsedService) var recentlyUsedService

	public var body: some ReducerProtocol<State, Action> {
		Scope(state: \.sortOrder, action: /Action.internal..Action.InternalAction.sortOrder) {
			SortOrder()
		}

		Scope(state: \.list, action: /Action.internal..Action.InternalAction.list) {
			ResourceList(fetchResources: bowlersDataProvider.observeBowlers)
		}

		Reduce<State, Action> { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didTapConfigureStatisticsButton:
					// TODO: handle configure statistics button press
					return .none

				case let .setNavigation(selection: .some(id)):
					return navigate(to: id, state: &state)

				case .setNavigation(selection: .none):
					return navigate(to: nil, state: &state)

				case .setEditorSheet(isPresented: true):
					state.editor = .init(mode: .create)
					return .none

				case .setEditorSheet(isPresented: false):
					state.editor = nil
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .list(.delegate(delegateAction)):
					switch delegateAction {
					case let .didEdit(bowler):
						state.editor = .init(mode: .edit(bowler))
						return .none

					case .didAddNew, .didTapEmptyStateButton:
						state.editor = .init(mode: .create)
						return .none

					case .didDelete, .didTap:
						return .none
					}

				case let .sortOrder(.delegate(delegateAction)):
					switch delegateAction {
					case .didTapOption:
						state.updateQuery()
						return .task { .internal(.list(.callback(.shouldRefreshData))) }
					}

				case let .editor(.delegate(delegateAction)):
					switch delegateAction {
					case .didFinishEditing:
						state.editor = nil
						return .none
					}

				case let .leagues(.delegate(delegateAction)):
					switch delegateAction {
					case .never:
						return .none
					}

				case .list(.internal), .list(.view), .list(.callback):
					return .none

				case .editor(.internal), .editor(.view), .editor(.binding):
					return .none

				case .leagues(.internal), .leagues(.view):
					return .none

				case .sortOrder(.internal), .sortOrder(.view):
					return .none
				}

			case .delegate:
				return .none
			}
		}
		.ifLet(\.editor, action: /Action.internal..Action.InternalAction.editor) {
			BowlerEditor()
		}
		.ifLet(\.selection, action: /Action.internal..Action.InternalAction.leagues) {
			Scope(state: \Identified<Bowler.ID, LeaguesList.State>.value, action: /.self) {
				LeaguesList()
			}
		}
	}

	private func navigate(to id: Bowler.ID?, state: inout State) -> EffectTask<Action> {
		if let id, let selection = state.list.resources?[id: id] {
			state.selection = Identified(.init(bowler: selection), id: selection.id)
			return .fireAndForget {
				try await clock.sleep(for: .seconds(1))
				recentlyUsedService.didRecentlyUseResource(.bowlers, selection.id)
			}
		} else {
			state.selection = nil
			return .none
		}
	}
}

extension BowlersList.State {
	mutating func updateQuery() {
		list.query = .init(filter: nil, ordering: sortOrder.ordering)
	}
}
