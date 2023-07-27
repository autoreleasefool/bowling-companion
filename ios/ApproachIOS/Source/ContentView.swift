import AppFeature
import ComposableArchitecture
import FeatureFlagsServiceInterface
import SwiftUI

#if DEBUG
import DatabaseServiceInterface
import DatabaseMockingServiceInterface
import Dependencies
import TestDatabaseUtilitiesLibrary
#endif

public struct ContentView: View {
	let store: Store = {
		#if DEBUG
		return .init(
			initialState: App.State(),
			reducer: {
				App()
					._printChanges()
//					.dependency(\.databaseMocking, .init(mockDatabase: {
//						@Dependency(\.database) var database
//						let writer = database.writer()
//						_ = try generatePopulatedDatabase(db: writer)
//					}))
			}
		)
		#else
		return .init(
			initialState: App.State(),
			reducer: App()
		)
		#endif
	}()

	public var body: some View {
		AppView(store: store)
	}
}

#if DEBUG
struct ContentViewPreviews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
#endif
