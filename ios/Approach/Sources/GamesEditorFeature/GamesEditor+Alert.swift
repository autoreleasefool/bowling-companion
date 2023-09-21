import ComposableArchitecture
import StringsLibrary

extension GamesEditor {
	func reduce(into state: inout State, duplicateLanesAction: GamesEditor.Destination.AlertAction) -> Effect<Action> {
		switch duplicateLanesAction {
		case .confirmDuplicateLanes:
			let currentGame = state.currentGameId
			let otherGames = state.bowlerGameIds.flatMap { $0.value }.filter { $0 != currentGame }
			return .run { _ in
				try await games.duplicateLanes(from: currentGame, toAllGames: otherGames)
			} catch: { error, send in
				await send(.internal(.didDuplicateLanes(.failure(error))))
			}

		case .didDismiss:
			state.destination = .gameDetails(.init(
				gameId: state.currentGameId,
				nextHeaderElement: state.nextHeaderElement,
				didChangeBowler: false
			))
			return .none
		}
	}
}

extension AlertState where Action == GamesEditor.Destination.AlertAction {
	static let duplicateLanes = Self {
		TextState(Strings.Game.Editor.Fields.Alley.Lanes.Duplicate.title)
	} actions: {
		ButtonState(action: .confirmDuplicateLanes) {
			TextState(Strings.Game.Editor.Fields.Alley.Lanes.Duplicate.copyToAll)
		}

		ButtonState(role: .cancel, action: .didDismiss) {
			TextState(Strings.Game.Editor.Fields.Alley.Lanes.Duplicate.dismiss)
		}
	} message: {
		TextState(Strings.Game.Editor.Fields.Alley.Lanes.Duplicate.message)
	}
}