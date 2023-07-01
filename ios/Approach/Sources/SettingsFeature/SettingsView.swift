import ComposableArchitecture
import FeatureActionLibrary
import FeatureFlagsListFeature
import OpponentsListFeature
import StringsLibrary
import SwiftUI
import SwiftUIExtensionsLibrary

public struct SettingsView: View {
	let store: StoreOf<Settings>

	struct ViewState: Equatable {
		let isShowingDeveloperOptions: Bool
		let showsOpponents: Bool

		init(state: Settings.State) {
			self.isShowingDeveloperOptions = state.isShowingDeveloperOptions
			self.showsOpponents = state.hasOpponentsEnabled
		}
	}

	enum ViewAction {
		case didTapPopulateDatabase
		case didTapFeatureFlags
		case didTapOpponents
		case didTapStatistics
	}

	public init(store: StoreOf<Settings>) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: Settings.Action.init) { viewStore in
			List {
				if viewStore.isShowingDeveloperOptions {
					Section {
						Button { viewStore.send(.didTapFeatureFlags) } label: {
							Text(Strings.Settings.FeatureFlags.title)
						}
						.buttonStyle(.navigation)

						Button { viewStore.send(.didTapPopulateDatabase) } label: {
							Text(Strings.Settings.DeveloperOptions.populateDatabase)
						}
					}
				}

				if viewStore.showsOpponents {
					Section {
						Button { viewStore.send(.didTapOpponents) } label: {
							Text(Strings.Opponent.List.title)
						}
						.buttonStyle(.navigation)
					}
				}

				Section {
					Button { viewStore.send(.didTapStatistics) } label: {
						Text(Strings.Settings.Statistics.title)
					}
					.buttonStyle(.navigation)
				}

				HelpSettingsView(store: store.scope(state: \.helpSettings, action: /Settings.Action.InternalAction.helpSettings))
				VersionView()
			}
			.navigationTitle(Strings.Settings.title)
		}
		.navigationDestination(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /Settings.Destination.State.opponentsList,
			action: Settings.Destination.Action.opponentsList
		) { store in
			OpponentsListView(store: store)
		}
		.navigationDestination(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /Settings.Destination.State.featureFlags,
			action: Settings.Destination.Action.featureFlags
		) { store in
			FeatureFlagsListView(store: store)
		}
		.navigationDestination(
			store: store.scope(state: \.$destination, action: { .internal(.destination($0)) }),
			state: /Settings.Destination.State.statistics,
			action: Settings.Destination.Action.statistics
		) { store in
			StatisticsSettingsView(store: store)
		}
	}
}

extension Settings.Action {
	init(action: SettingsView.ViewAction) {
		switch action {
		case .didTapPopulateDatabase:
			self = .view(.didTapPopulateDatabase)
		case .didTapFeatureFlags:
			self = .view(.didTapFeatureFlags)
		case .didTapOpponents:
			self = .view(.didTapOpponents)
		case .didTapStatistics:
			self = .view(.didTapStatistics)
		}
	}
}
