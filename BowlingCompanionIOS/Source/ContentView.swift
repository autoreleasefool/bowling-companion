import AppFeature
import ComposableArchitecture
import SwiftUI

struct ContentView: View {
	let store = Store(
		initialState: App.State(),
		reducer: App()
	)

	var body: some View {
		NavigationStack {
			AppView(store: store)
		}
	}
}

#if DEBUG
struct ContentViewPreviews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
#endif
