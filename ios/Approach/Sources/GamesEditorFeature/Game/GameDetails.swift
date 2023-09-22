import AnalyticsServiceInterface
import AssetsLibrary
import ComposableArchitecture
import DateTimeLibrary
import EquatableLibrary
import ExtensionsLibrary
import FeatureActionLibrary
import FeatureFlagsLibrary
import FeatureFlagsServiceInterface
import GamesRepositoryInterface
import GearRepositoryInterface
import MatchPlaysRepositoryInterface
import ModelsLibrary
import ModelsViewsLibrary
import PickableModelsLibrary
import ResourcePickerLibrary
import StringsLibrary
import SwiftUI
import ViewsLibrary

// swiftlint:disable:next type_body_length
public struct GameDetails: Reducer {
	public struct State: Equatable {
		public var gameId: Game.ID
		public var game: Game.Edit?
		public var isScoreAlertPresented = false
		public var didJustToggleScoringMethod = false
		public var alertScore: Int = 0

		public var nextHeaderElement: GameDetailsHeader.State.NextElement?
		public var shouldHeaderShimmer: Bool

		public let isGearEnabled: Bool
		public let isOpponentsEnabled: Bool

		@BindingState public var isSelectingLanes: Bool = false

		public var _gameDetailsHeader: GameDetailsHeader.State = .init()

		@PresentationState public var destination: Destination.State?

		var isEditable: Bool { game?.locked != .locked }

		var laneLabels: String {
			if let game, !game.lanes.isEmpty {
				return game.lanes.map(\.label).joined(separator: ", ")
			} else {
				return Strings.none
			}
		}

		init(
			gameId: Game.ID,
			nextHeaderElement: GameDetailsHeader.State.NextElement?,
			didChangeBowler: Bool
		) {
			self.gameId = gameId
			self.nextHeaderElement = nextHeaderElement
			self.shouldHeaderShimmer = didChangeBowler

			@Dependency(\.featureFlags) var featureFlags
			self.isGearEnabled = featureFlags.isEnabled(.gear)
			self.isOpponentsEnabled = featureFlags.isEnabled(.opponents)
		}
	}

	public enum Action: FeatureAction, Equatable {
		public enum ViewAction: BindableAction, Equatable {
			case didStartTask
			case didToggleLock
			case didToggleExclude
			case didTapMatchPlay
			case didToggleScoringMethod
			case didTapManualScore
			case didTapGear
			case didDismissScoreAlert
			case didTapSaveScore
			case didTapCancelScore
			case didTapManageLanes
			case didSetAlertScore(String)
			case didSwipeGear(SwipeAction, id: Gear.ID)
			case didMeasureMinimumSheetContentSize(CGSize)
			case didMeasureSectionHeaderContentSize(CGSize)
			case binding(BindingAction<State>)
		}
		public enum DelegateAction: Equatable {
			case didRequestLanePicker
			case didProceed(to: GameDetailsHeader.State.NextElement)
			case didEditMatchPlay(TaskResult<MatchPlay.Edit?>)
			case didClearManualScore
			case didProvokeLock
			case didEditGame(Game.Edit?)
			case didMeasureMinimumSheetContentSize(CGSize)
			case didMeasureSectionHeaderContentSize(CGSize)
		}
		public enum InternalAction: Equatable {
			case didLoadGame(TaskResult<Game.Edit?>)
			case gameDetailsHeader(GameDetailsHeader.Action)
			case destination(PresentationAction<Destination.Action>)
		}

		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
	}

	public struct Destination: Reducer {
		public enum State: Equatable {
			case gearPicker(ResourcePicker<Gear.Summary, AlwaysEqual<Void>>.State)
			case matchPlay(MatchPlayEditor.State)
		}
		public enum Action: Equatable {
			case gearPicker(ResourcePicker<Gear.Summary, AlwaysEqual<Void>>.Action)
			case matchPlay(MatchPlayEditor.Action)
		}

		@Dependency(\.gear) var gear

		public var body: some ReducerOf<Self> {
			Scope(state: /State.gearPicker, action: /Action.gearPicker) {
				ResourcePicker { _ in gear.list(ordered: .byName) }
			}
			Scope(state: /State.matchPlay, action: /Action.matchPlay) {
				MatchPlayEditor()
			}
		}
	}

	enum CancelID {
		case saveMatchPlay
		case observation
	}

	public enum SwipeAction: Equatable {
		case delete
	}

	@Dependency(\.games) var games
	@Dependency(\.matchPlays) var matchPlays
	@Dependency(\.uuid) var uuid

	public var body: some ReducerOf<Self> {
		BindingReducer(action: /Action.view)

		Scope(state: \.gameDetailsHeader, action: /Action.internal..Action.InternalAction.gameDetailsHeader) {
			GameDetailsHeader()
		}

		Reduce<State, Action> { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .didStartTask:
					return .merge(
						.run { [gameId = state.gameId] send in
							for try await game in games.observe(gameId) {
								await send(.internal(.didLoadGame(.success(game))))
							}
						} catch: { error, send in
							await send(.internal(.didLoadGame(.failure(error))))
						}
						.cancellable(id: CancelID.observation, cancelInFlight: true),
						state.startShimmer()
					)

				case .didToggleLock:
					state.game?.locked.toNext()
					return .send(.delegate(.didEditGame(state.game)))

				case .didToggleExclude:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					state.game?.excludeFromStatistics.toNext()
					return .send(.delegate(.didEditGame(state.game)))

				case .didTapGear:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					let gear = Set(state.game?.gear.map(\.id) ?? [])
					state.destination = .gearPicker(.init(
						selected: gear,
						query: .init(()),
						showsCancelHeaderButton: false
					))
					return .none

				case .didTapManageLanes:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					return .send(.delegate(.didRequestLanePicker))

				case .didToggleScoringMethod:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					return toggleScoringMethod(in: &state)

				case .didDismissScoreAlert:
					state.didJustToggleScoringMethod = false
					state.isScoreAlertPresented = false
					return .none

				case .didTapSaveScore:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					state.game?.score = max(min(state.alertScore, 450), 0)
					return .send(.delegate(.didEditGame(state.game)))

				case .didTapCancelScore:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					if state.didJustToggleScoringMethod {
						state.didJustToggleScoringMethod = false
						return toggleScoringMethod(in: &state)
					} else {
						return .none
					}

				case .didTapManualScore:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					state.alertScore = state.game?.score ?? 0
					state.isScoreAlertPresented = true
					return .none

				case let .didSetAlertScore(string):
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					if !string.isEmpty, let score = Int(string) {
						state.alertScore = max(min(score, 450), 0)
					}
					return .none

				case .didTapMatchPlay:
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					guard let game = state.game else { return .none }
					if let matchPlay = game.matchPlay {
						state.destination = .matchPlay(.init(matchPlay: matchPlay))
						return .none
					} else {
						let matchPlay = MatchPlay.Edit(gameId: game.id, id: uuid())
						state.game?.matchPlay = matchPlay
						state.destination = .matchPlay(.init(matchPlay: matchPlay))
						return createMatchPlay(matchPlay)
					}

				case let .didSwipeGear(.delete, id):
					guard state.isEditable else { return .send(.delegate(.didProvokeLock)) }
					state.game?.gear.remove(id: id)
					return .send(.delegate(.didEditGame(state.game)))

				case let .didMeasureMinimumSheetContentSize(size):
					return .send(.delegate(.didMeasureMinimumSheetContentSize(size)))

				case let .didMeasureSectionHeaderContentSize(size):
					return .send(.delegate(.didMeasureSectionHeaderContentSize(size)))

				case .binding(\.$isSelectingLanes):
					guard state.isEditable else {
						state.isSelectingLanes = state.game?.lanes.isEmpty != true
						return .send(.delegate(.didProvokeLock))
					}

					if !state.isSelectingLanes {
						state.game?.lanes.removeAll()
						return .send(.delegate(.didEditGame(state.game)))
					}
					return .none

				case .binding:
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .didLoadGame(.success(game)):
					guard let game, game.id == state.gameId else { return .none }
					state.game = game
					state.isSelectingLanes = !game.lanes.isEmpty
					return .none

				case .didLoadGame(.failure):
					// TODO: Handle error observing game -- not actually sure we need to care about the error here
					return .none

				case let .destination(.presented(.gearPicker(.delegate(delegateAction)))):
					switch delegateAction {
					case let .didChangeSelection(gear):
						state.game?.gear = .init(uniqueElements: gear)
						return .send(.delegate(.didEditGame(state.game)))
					}

				case let .destination(.presented(.matchPlay(.delegate(delegateAction)))):
					switch delegateAction {
					case let .didEditMatchPlay(matchPlay):
						if matchPlay == nil {
							return deleteMatchPlay(state: &state)
						} else {
							state.game?.matchPlay = matchPlay
							return .send(.delegate(.didEditMatchPlay(.success(state.game?.matchPlay))))
						}
					}

				case let .gameDetailsHeader(.delegate(delegateAction)):
					switch delegateAction {
					case let .didProceed(next):
						return .send(.delegate(.didProceed(to: next)))
					}

				case .destination(.dismiss),
						.destination(.presented(.matchPlay(.internal))), .destination(.presented(.matchPlay(.view))),
						.destination(.presented(.gearPicker(.internal))), .destination(.presented(.gearPicker(.view))),
						.gameDetailsHeader(.internal), .gameDetailsHeader(.view):
					return .none

				}

			case .delegate:
				return .none
			}
		}
		.ifLet(\.$destination, action: /Action.internal..Action.InternalAction.destination) {
			Destination()
		}

		AnalyticsReducer<State, Action> { state, action in
			switch action {
			case .view(.didTapSaveScore):
				guard let gameId = state.game?.id else { return nil }
				return Analytics.Game.ManualScoreSet(gameId: gameId)
			default:
				return nil
			}
		}
	}

	private func toggleScoringMethod(in state: inout State) -> Effect<Action> {
		state.game?.scoringMethod.toNext()
		switch state.game?.scoringMethod {
		case .byFrame:
			return .send(.delegate(.didClearManualScore))
		case .manual:
			state.alertScore = state.game?.score ?? 0
			state.didJustToggleScoringMethod = true
			state.isScoreAlertPresented = true
			return .none
		case .none:
			return .none
		}
	}

	private func createMatchPlay(_ matchPlay: MatchPlay.Edit) -> Effect<Action> {
		return .run { send in
			await send(.delegate(.didEditMatchPlay(TaskResult {
				try await matchPlays.create(matchPlay)
				return matchPlay
			})))
		}.cancellable(id: CancelID.saveMatchPlay)
	}

	private func deleteMatchPlay(state: inout State) -> Effect<Action> {
		guard let matchPlay = state.game?.matchPlay else { return .none }
		state.game?.matchPlay = nil
		return .concatenate(
			.cancel(id: CancelID.saveMatchPlay),
			.run { send in
				await send(.delegate(.didEditMatchPlay(TaskResult {
					try await matchPlays.delete(matchPlay.id)
					return nil
				})))
			}
		)
	}
}

extension GameDetails.State {
	mutating func loadGameDetails(forGameId: Game.ID, didChangeBowler: Bool) -> Effect<GameDetails.Action> {
		gameId = forGameId
		shouldHeaderShimmer = didChangeBowler
		return .send(.view(.didStartTask))
	}

	mutating func startShimmer() -> Effect<GameDetails.Action> {
		guard shouldHeaderShimmer else { return .none }
		shouldHeaderShimmer = false
		return _gameDetailsHeader.shouldStartShimmering()
			.map { .internal(.gameDetailsHeader($0)) }
	}
}

extension GameDetails.State {
	var gameDetailsHeader: GameDetailsHeader.State {
		get {
			var gameDetailsHeader = _gameDetailsHeader
			gameDetailsHeader.currentBowlerName = game?.bowler.name ?? ""
			gameDetailsHeader.currentLeagueName = game?.league.name ?? ""
			gameDetailsHeader.next = nextHeaderElement
			return gameDetailsHeader
		}
		set {
			_gameDetailsHeader = newValue
		}
	}
}
