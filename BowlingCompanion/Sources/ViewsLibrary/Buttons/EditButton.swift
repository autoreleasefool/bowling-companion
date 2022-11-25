import SwiftUI

public struct EditButton: View {
	let perform: () -> Void

	public init(perform: @escaping () -> Void) {
		self.perform = perform
	}

	public var body: some View {
		Button(action: perform) {
			Label("Edit", systemImage: "pencil")
		}
		.tint(.blue)
	}
}
