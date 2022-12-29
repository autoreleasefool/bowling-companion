import ComposableArchitecture
import DateTimeLibrary
import GameEditorFeature
import SharedModelsLibrary
import SwiftUI

public struct SeriesSidebarView: View {
	let store: StoreOf<SeriesSidebar>

	struct ViewState: Equatable {
		let title: String
		let games: IdentifiedArrayOf<Game>
		let selection: Game.ID?

		init(state: SeriesSidebar.State) {
			self.title = state.series.date.longFormat
			self.games = state.games
			self.selection = state.selection?.id
		}
	}

	enum ViewAction {
		case observeGames
		case setNavigation(selection: Game.ID?)
	}

	public init(store: StoreOf<SeriesSidebar>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: SeriesSidebar.Action.init) { viewStore in
			List(viewStore.games) { game in
				NavigationLink(
					destination: IfLetStore(
						store.scope(
							state: \.selection?.value,
							action: SeriesSidebar.Action.gameEditor
						)
					) {
						GameEditorView(store: $0)
					},
					tag: game.id,
					selection: viewStore.binding(
						get: \.selection,
						send: SeriesSidebarView.ViewAction.setNavigation(selection:)
					)
				) {
					Text("Game \(game.ordinal)")
				}
			}
			.navigationTitle(viewStore.title)
			.task { await viewStore.send(.observeGames).finish() }
		}
	}
}

extension SeriesSidebar.Action {
	init(action: SeriesSidebarView.ViewAction) {
		switch action {
		case .observeGames:
			self = .observeGames
		case let .setNavigation(selection):
			self = .setNavigation(selection: selection)
		}
	}
}
