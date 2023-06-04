import AssetsLibrary
import Dependencies
import ModelsLibrary
import SwiftUI

public struct AvatarView: View {
	let avatar: Avatar.Summary
	let size: CGFloat

	@State private var image: UIImage?

	public init(_ avatar: Avatar.Summary, size: CGFloat) {
		self.avatar = avatar
		self.size = size
	}

	public var body: some View {
		Group {
			if let image {
				Image(uiImage: image)
					.resizable()
					.scaledToFit()
					.frame(width: size, height: size)
					.cornerRadius(size)
			} else {
				Color.clear
					.frame(width: size, height: size)
					.cornerRadius(size)
			}
		}.task {
			@Dependency(\.avatars) var avatars: AvatarService
			image = await avatars.render(avatar)
		}
	}
}