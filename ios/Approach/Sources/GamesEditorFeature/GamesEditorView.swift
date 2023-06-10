import AssetsLibrary
import ComposableArchitecture
import EquatableLibrary
import FeatureActionLibrary
import ModelsLibrary
import ResourcePickerLibrary
import ScoreSheetFeature
import StringsLibrary
import SwiftUI
import SwiftUIExtensionsLibrary

public struct GamesEditorView: View {
	let store: StoreOf<GamesEditor>

	@Environment(\.safeAreaInsets) private var safeAreaInsets
	@State private var headerContentSize: CGSize = .zero
	@State private var frameContentSize: CGSize = .zero
	@State private var sheetContentSize: CGSize = .zero
	@State private var windowContentSize: CGSize = .zero
	@State private var minimumSheetContentSize: CGSize = .zero
	@State private var sectionHeaderContentSize: CGSize = .zero

	struct ViewState: Equatable {
		let sheetDetent: PresentationDetent
		let willAdjustLaneLayoutAt: Date
		let backdropSize: CGSize

		let isScoreSheetVisible: Bool

		let manualScore: Int?

		let bowlerName: String?
		let leagueName: String?

		init(state: GamesEditor.State) {
			self.sheetDetent = state.sheetDetent
			self.willAdjustLaneLayoutAt = state.willAdjustLaneLayoutAt
			self.backdropSize = state.backdropSize
			self.isScoreSheetVisible = state.isScoreSheetVisible
			self.bowlerName = state.game?.bowler.name
			self.leagueName = state.game?.league.name
			if let game = state.game {
				switch game.scoringMethod {
				case .byFrame:
					self.manualScore = nil
				case .manual:
					self.manualScore = game.score
				}
			} else {
				self.manualScore = nil
			}
		}
	}

	enum ViewAction {
		case didAppear
		case didChangeDetent(PresentationDetent)
		case didAdjustBackdropSize(CGSize)
	}

	public init(store: StoreOf<GamesEditor>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: GamesEditor.Action.init) { viewStore in
			VStack {
				GamesHeaderView(store: store.scope(state: \.gamesHeader, action: /GamesEditor.Action.InternalAction.gamesHeader))
					.measure(key: HeaderContentSizeKey.self, to: $headerContentSize)

				VStack {
					if let manualScore = viewStore.manualScore {
						Spacer()

						VStack {
							Text(String(manualScore))
								.font(.largeTitle)
							Text(Strings.Game.Editor.Fields.ManualScore.caption)
								.font(.caption)
						}
						.padding()
						.background(.regularMaterial, in: RoundedRectangle(cornerRadius: .standardRadius, style: .continuous))
						.padding()

						Spacer()

					} else {

						Spacer()

						frameEditor
							.padding(.top)

						Spacer()

						rollEditor
							.padding(.horizontal)

						if viewStore.isScoreSheetVisible {
							scoreSheet
								.padding(.top)
								.padding(.horizontal)
								.measure(key: FrameContentSizeKey.self, to: $frameContentSize)
						}
					}
				}
				.frame(idealWidth: viewStore.backdropSize.width, maxHeight: viewStore.backdropSize.height)

				Spacer()
			}
			.measure(key: WindowContentSizeKey.self, to: $windowContentSize)
			.background(alignment: .top) {
				Image(uiImage: .laneBackdrop)
					.resizable(resizingMode: .stretch)
					.fixedSize(horizontal: true, vertical: false)
					.frame(width: viewStore.backdropSize.width, height: getBackdropHeight(viewStore))
					.padding(.top, headerContentSize.height)
			}
			.background(Color.black)
			.toolbar(.hidden, for: .tabBar, .navigationBar)
			.sheet(
				store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
				state: /GamesEditor.Destination.State.gameDetails,
				action: GamesEditor.Destination.Action.gameDetails
			) { (store: StoreOf<GameDetails>) in
				gameDetails(viewStore: viewStore, gameDetailsStore: store)
			}
			.onChange(of: viewStore.willAdjustLaneLayoutAt) { _ in
				viewStore.send(.didAdjustBackdropSize(getMeasuredBackdropSize(viewStore)), animation: .easeInOut)
			}
			.onChange(of: sheetContentSize) { _ in
				viewStore.send(.didAdjustBackdropSize(getMeasuredBackdropSize(viewStore)), animation: .easeInOut)
			}
		}
		.sheet(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /GamesEditor.Destination.State.ballPicker,
			action: GamesEditor.Destination.Action.ballPicker
		) { (store: StoreOf<ResourcePicker<Gear.Summary, Bowler.ID>>) in
			ballPicker(store: store)
		}
		.sheet(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /GamesEditor.Destination.State.opponentPicker,
			action: GamesEditor.Destination.Action.opponentPicker
		) { (store: StoreOf<ResourcePicker<Bowler.Summary, AlwaysEqual<Void>>>) in
			opponentPicker(store: store)
		}
		.sheet(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /GamesEditor.Destination.State.gearPicker,
			action: GamesEditor.Destination.Action.gearPicker
		) { (store: StoreOf<ResourcePicker<Gear.Summary, AlwaysEqual<Void>>>) in
			gearPicker(store: store)
		}
		.sheet(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /GamesEditor.Destination.State.settings,
			action: GamesEditor.Destination.Action.settings
		) { (store: StoreOf<GamesSettings>) in
			gamesSettings(store: store)
		}
	}

	private func gameDetails(
		viewStore: ViewStore<ViewState, ViewAction>,
		gameDetailsStore: StoreOf<GameDetails>
	) -> some View {
		Form {
			Section {
				IfLetStore(store.scope(state: \.gameDetailsHeader, action: /GamesEditor.Action.InternalAction.gameDetailsHeader)) {
					GameDetailsHeaderView(store: $0)
						.measure(key: MinimumSheetContentSizeKey.self, to: $minimumSheetContentSize)
				}
			} header: {
				Color.clear
					.measure(key: SectionHeaderContentSizeKey.self, to: $sectionHeaderContentSize)
			}

			GameDetailsView(store: gameDetailsStore)
		}
		.padding(.top, -sectionHeaderContentSize.height)
		.frame(minHeight: 50)
		.edgesIgnoringSafeArea(.bottom)
		.presentationDetents(
			[
				.height(minimumSheetContentSize.height + 40),
				.medium,
				.large,
			],
			selection: viewStore.binding(get: \.sheetDetent, send: ViewAction.didChangeDetent)
		)
		.presentationBackgroundInteraction(.enabled(upThrough: .medium))
		.interactiveDismissDisabled(true)
		.measure(key: SheetContentSizeKey.self, to: $sheetContentSize)
	}

	private func ballPicker(store: StoreOf<ResourcePicker<Gear.Summary, Bowler.ID>>) -> some View {
		NavigationStack {
			ResourcePickerView(store: store) {
				Gear.View(gear: $0)
			}
		}
	}

	private func opponentPicker(store: StoreOf<ResourcePicker<Bowler.Summary, AlwaysEqual<Void>>>) -> some View {
		NavigationStack {
			ResourcePickerView(store: store) {
				Text($0.name)
			}
		}
	}

	private func gearPicker(store: StoreOf<ResourcePicker<Gear.Summary, AlwaysEqual<Void>>>) -> some View {
		NavigationStack {
			ResourcePickerView(store: store) {
				Gear.View(gear: $0)
			}
		}
	}

	private func gamesSettings(store: StoreOf<GamesSettings>) -> some View {
		NavigationStack {
			GamesSettingsView(store: store)
		}
	}

	private var frameEditor: some View {
		IfLetStore(store.scope(state: \.frameEditor, action: /GamesEditor.Action.InternalAction.frameEditor)) {
			FrameEditorView(store: $0)
		}
	}

	private var rollEditor: some View {
		IfLetStore(store.scope(state: \.rollEditor, action: /GamesEditor.Action.InternalAction.rollEditor)) {
			RollEditorView(store: $0)
		}
	}

	private var scoreSheet: some View {
		IfLetStore(store.scope(state: \.scoreSheet, action: /GamesEditor.Action.InternalAction.scoreSheet)) {
			ScoreSheetView(store: $0)
		}
	}

	private func getMeasuredBackdropSize(_ viewStore: ViewStore<ViewState, ViewAction>) -> CGSize {
		let sheetContentSize = viewStore.sheetDetent == .large ? .zero : self.sheetContentSize
		return .init(
			width: windowContentSize.width,
			height: windowContentSize.height - sheetContentSize.height - headerContentSize.height
				- safeAreaInsets.bottom - CGFloat.largeSpacing
		)
	}

	private func getBackdropHeight(_ viewStore: ViewStore<ViewState, ViewAction>) -> CGFloat {
		max(viewStore.backdropSize.height - (viewStore.isScoreSheetVisible ? frameContentSize.height : 0), 0)
	}
}

extension GamesEditor.Action {
	init(action: GamesEditorView.ViewAction) {
		switch action {
		case .didAppear:
			self = .view(.didAppear)
		case let .didChangeDetent(newDetent):
			self = .view(.didChangeDetent(newDetent))
		case let .didAdjustBackdropSize(newSize):
			self = .view(.didAdjustBackdropSize(newSize))
		}
	}
}

private struct MinimumSheetContentSizeKey: PreferenceKey, CGSizePreferenceKey {}
private struct SheetContentSizeKey: PreferenceKey, CGSizePreferenceKey {}
private struct WindowContentSizeKey: PreferenceKey, CGSizePreferenceKey {}
private struct HeaderContentSizeKey: PreferenceKey, CGSizePreferenceKey {}
private struct FrameContentSizeKey: PreferenceKey, CGSizePreferenceKey {}
private struct SectionHeaderContentSizeKey: PreferenceKey, CGSizePreferenceKey {}
