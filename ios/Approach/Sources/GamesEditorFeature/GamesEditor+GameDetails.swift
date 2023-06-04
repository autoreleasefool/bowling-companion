import ComposableArchitecture

extension GamesEditor.State {
	var gameDetails: GameDetails.State? {
		get {
			guard let _gameDetails, let game else { return nil }
			var gameDetails = _gameDetails
			gameDetails.game = game
			return gameDetails
		}
		set {
			guard let newValue, currentGameId == newValue.game.id else { return }
			guard isEditable else {
				// Always enable toggling the locked status of the game
				if _gameDetails?.game.locked != newValue.game.locked {
					_gameDetails?.game.locked = newValue.game.locked
					game?.locked = newValue.game.locked
				}
				return
			}
			_gameDetails = newValue
			game = newValue.game
		}
	}
}

extension GamesEditor {
	func reduce(into state: inout State, gameDetailsAction: GameDetails.Action) -> Effect<Action> {
		switch gameDetailsAction {
		case let .delegate(delegateAction):
			switch delegateAction {
			case .didRequestOpponentPicker:
				let opponent = Set([state.game?.matchPlay?.opponent?.id].compactMap { $0 })
				state._opponentPicker.initialSelection = opponent
				state._opponentPicker.selected = opponent
				state.sheet.transition(to: .opponentPicker)
				return .none

			case .didRequestGearPicker:
				let gear = Set(state.game?.gear.map(\.id) ?? [])
				state._gearPicker.initialSelection = gear
				state._gearPicker.selected = gear
				state.sheet.transition(to: .gearPicker)
				return .none

			case .didEditGame:
				return save(game: state.game)

			case .didClearManualScore:
				return updateScoreSheet(from: state)
			}

		case .internal, .view:
			return .none
		}
	}
}