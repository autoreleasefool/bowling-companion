import ComposableArchitecture
import ModelsLibrary
import StringsLibrary
import SwiftUI
import ViewsLibrary

public struct GameDetailsView: View {
	let store: StoreOf<GameDetails>

	enum ViewAction {
		case didTapOpponent
		case didTapGear
		case didSwipeGear(GameDetails.SwipeAction, id: Gear.ID)
		case didToggleLock
		case didToggleExclude
		case didToggleMatchPlay
		case didToggleScoringMethod
		case didTapManualScore
		case didDismissScoreAlert
		case didTapSaveScore
		case didTapCancelScore
		case didSetMatchPlayResult(MatchPlay.Result?)
		case didSetMatchPlayScore(String)
		case didSetAlertScore(String)
	}

	init(store: StoreOf<GameDetails>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: { $0 }, send: GameDetails.Action.init, content: { viewStore in
			Section {
				if viewStore.game.gear.isEmpty {
					Text(Strings.Game.Editor.Fields.Gear.help)
				} else {
					ForEach(viewStore.game.gear) { gear in
						Gear.View(gear: gear)
							.swipeActions(allowsFullSwipe: false) {
								DeleteButton { viewStore.send(.didSwipeGear(.delete, id: gear.id)) }
							}
					}
				}
			} header: {
				HStack(alignment: .firstTextBaseline) {
					Text(Strings.Gear.List.title)
					Spacer()
					Button { viewStore.send(.didTapGear) } label: {
						Text(Strings.Action.select)
							.font(.caption)
					}
				}
			} footer: {
				if !viewStore.game.gear.isEmpty {
					Text(Strings.Game.Editor.Fields.Gear.help)
				}
			}

			Section(Strings.MatchPlay.title) {
				Toggle(
					Strings.MatchPlay.record,
					isOn: viewStore.binding(get: { $0.game.matchPlay != nil }, send: ViewAction.didToggleMatchPlay)
				)

				if let matchPlay = viewStore.game.matchPlay {
					Button { viewStore.send(.didTapOpponent) } label: {
						HStack {
							LabeledContent(
								Strings.Opponent.title,
								value: viewStore.game.matchPlay?.opponent?.name ?? Strings.none
							)
							Image(systemName: "chevron.forward")
								.resizable()
								.scaledToFit()
								.frame(width: .tinyIcon, height: .tinyIcon)
								.foregroundColor(Color(uiColor: .secondaryLabel))
						}
						.contentShape(Rectangle())
					}
					.buttonStyle(TappableElement())

					TextField(
						Strings.MatchPlay.Properties.opponentScore,
						text: viewStore.binding(
							get: {
								if let score = $0.game.matchPlay?.opponentScore, score > 0 {
									return String(score)
								} else {
									return ""
								}
							},
							send: ViewAction.didSetMatchPlayScore
						)
					)
					.keyboardType(.numberPad)

					Picker(
						Strings.MatchPlay.Properties.result,
						selection: viewStore.binding(get: { _ in matchPlay.result }, send: ViewAction.didSetMatchPlayResult)
					) {
						Text("").tag(nil as MatchPlay.Result?)
						ForEach(MatchPlay.Result.allCases) {
							Text(String(describing: $0)).tag(Optional($0))
						}
					}
				}
			}

			if let alley = viewStore.game.series.alley?.name {
				Section(Strings.Alley.title) {
					LabeledContent(Strings.Alley.Title.bowlingAlley, value: alley)
					// TODO: add lane picker for game
				}
			}

			Section {
				Toggle(
					Strings.Game.Editor.Fields.ScoringMethod.label,
					isOn: viewStore.binding(get: { $0.game.scoringMethod == .manual }, send: ViewAction.didToggleScoringMethod)
				)

				if viewStore.game.scoringMethod == .manual {
					Button { viewStore.send(.didTapManualScore) } label: {
						Text(String(viewStore.game.score))
					}
				}
			} footer: {
				Text(Strings.Game.Editor.Fields.ScoringMethod.help)
			}
			.alert(
				Strings.Game.Editor.Fields.ManualScore.title,
				isPresented: viewStore.binding(get: \.isScoreAlertPresented, send: ViewAction.didDismissScoreAlert)
			) {
				TextField(
					Strings.Game.Editor.Fields.ManualScore.prompt,
					text: viewStore.binding(
						get: { $0.alertScore > 0 ? String($0.alertScore) : "" },
						send: ViewAction.didSetAlertScore
					)
				)
				.keyboardType(.numberPad)
				Button(Strings.Action.save) { viewStore.send(.didTapSaveScore) }
				Button(Strings.Action.cancel, role: .cancel) { viewStore.send(.didTapCancelScore) }
			}

			Section {
				Toggle(
					Strings.Game.Editor.Fields.Lock.label,
					isOn: viewStore.binding(get: { $0.game.locked == .locked }, send: ViewAction.didToggleLock)
				)
			} footer: {
				Text(Strings.Game.Editor.Fields.Lock.help)
			}

			Section {
				Toggle(
					Strings.Game.Editor.Fields.ExcludeFromStatistics.label,
					isOn: viewStore.binding(get: { $0.game.excludeFromStatistics == .exclude }, send: ViewAction.didToggleExclude)
				)
			} footer: {
				// TODO: check if series or league is locked and display different help message
				Text(Strings.Game.Editor.Fields.ExcludeFromStatistics.help)
			}
		})
	}
}

extension GameDetails.Action {
	init(action: GameDetailsView.ViewAction) {
		switch action {
		case .didToggleLock:
			self = .view(.didToggleLock)
		case .didToggleExclude:
			self = .view(.didToggleExclude)
		case .didToggleMatchPlay:
			self = .view(.didToggleMatchPlay)
		case .didToggleScoringMethod:
			self = .view(.didToggleScoringMethod)
		case .didTapManualScore:
			self = .view(.didTapManualScore)
		case .didDismissScoreAlert:
			self = .view(.didDismissScoreAlert)
		case .didTapCancelScore:
			self = .view(.didTapCancelScore)
		case .didTapSaveScore:
			self = .view(.didTapSaveScore)
		case let .didSetMatchPlayResult(result):
			self = .view(.didSetMatchPlayResult(result))
		case let .didSetMatchPlayScore(score):
			self = .view(.didSetMatchPlayScore(score))
		case let .didSetAlertScore(score):
			self = .view(.didSetAlertScore(score))
		case .didTapOpponent:
			self = .delegate(.didRequestOpponentPicker)
		case .didTapGear:
			self = .delegate(.didRequestGearPicker)
		case let .didSwipeGear(action, id):
			self = .view(.didSwipeGear(action, id: id))
		}
	}
}

extension MatchPlay.Result: CustomStringConvertible {
	public var description: String {
		switch self {
		case .lost: return Strings.MatchPlay.Properties.Result.lost
		case .tied: return Strings.MatchPlay.Properties.Result.tied
		case .won: return Strings.MatchPlay.Properties.Result.won
		}
	}
}