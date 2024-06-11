import AssetsLibrary
import ModelsLibrary
import SwiftUI
import SwiftUIExtensionsPackageLibrary
import ViewsLibrary

public struct ScoreSheet: View {
	let game: ScoredGame
	let configuration: Configuration
	let contentSize: CGSize
	@Binding var selection: Selection

	public init(
		game: ScoredGame,
		configuration: Configuration,
		contentSize: CGSize,
		selection: Binding<Selection>
	) {
		self.game = game
		self.configuration = configuration
		self.contentSize = contentSize
		self._selection = selection
	}

	public struct Selection: Hashable {
		public var frameIndex: Int
		public var rollIndex: Int

		public init(frameIndex: Int, rollIndex: Int) {
			self.frameIndex = frameIndex
			self.rollIndex = rollIndex
		}

		var isLast: Bool { Frame.isLast(frameIndex) }
		var frameId: FrameID { .init(frameIndex: frameIndex) }

		public static let none: Self = .init(frameIndex: -1, rollIndex: -1)
	}

	struct FrameID: Hashable {
		let frameIndex: Int
	}

	public var body: some View {
		Grid(horizontalSpacing: 0, verticalSpacing: 0) {
			if configuration.railOnTop {
				GridRow {
					ForEach(game.frames, id: \.index) { frame in
						railView(forFrame: frame)
							.gridCellColumns(Frame.NUMBER_OF_ROLLS)
					}
				}
			}

			GridRow {
				ForEach(game.frames, id: \.index) { frame in
					rollViews(forFrame: frame)
				}
			}

			GridRow {
				ForEach(game.frames, id: \.index) { frame in
					frameView(forFrame: frame)
						.gridCellColumns(Frame.NUMBER_OF_ROLLS)
				}
			}

			if !configuration.railOnTop {
				GridRow {
					ForEach(game.frames, id: \.index) { frame in
						railView(forFrame: frame)
							.gridCellColumns(Frame.NUMBER_OF_ROLLS)
					}
				}
			}
		}
	}

	private func frameView(forFrame frame: ScoredFrame) -> some View {
		Button { selection = .init(frameIndex: frame.index, rollIndex: 0) } label: {
			Text(frame.displayValue ?? " ")
				.frame(maxWidth: .infinity)
				.padding(.smallSpacing)
				.foregroundColor(foreground(forFrameIndex: frame.index))
				.background(background(forFrameIndex: frame.index))
				.roundCorners(
					topLeading: configuration.roundTopFrameCorners && frame.index == 0,
					topTrailing: configuration.roundTopFrameCorners && Frame.isLast(frame.index),
					bottomLeading: configuration.roundBottomFrameCorners && frame.index == 0,
					bottomTrailing: configuration.roundBottomFrameCorners && Frame.isLast(frame.index)
				)
		}
		.id(FrameID(frameIndex: frame.index))
		.buttonStyle(TappableElement())
		.border(edges: frame.index == 0 ? [] : [.leading], color: configuration.border)
	}

	private func rollViews(forFrame frame: ScoredFrame) -> some View {
		ForEach(frame.rolls, id: \.index) { roll in
			Button { selection = .init(frameIndex: frame.index, rollIndex: roll.index) } label: {
				Text(roll.displayValue ?? " ")
					.font(.caption)
					.minimumScaleFactor(0.2)
					.lineLimit(1)
					.frame(width: contentSize.width / 12)
					.padding(.smallSpacing)
					.foregroundColor(
						foreground(
							forRollIndex: roll.index,
							inFrame: frame.index,
							didFoul: roll.didFoul,
							isSecondary: roll.isSecondary
						)
					)
					.background(background(forRollIndex: roll.index, inFrame: frame.index))
					.roundCorners(
						topLeading: configuration.roundTopRollCorners && frame.index == 0 && roll.index == 0,
						topTrailing: configuration.roundTopRollCorners && Frame.isLast(frame.index) && Frame.isLastRoll(roll.index),
						bottomLeading: configuration.roundBottomRollCorners && frame.index == 0 && roll.index == 0,
						bottomTrailing: configuration.roundBottomRollCorners && Frame.isLast(frame.index) && Frame.isLastRoll(roll.index)
					)
			}
			.id(Selection(frameIndex: frame.index, rollIndex: roll.index))
			.buttonStyle(TappableElement())
			.border(
				edges: [
					.bottom,
					Frame.isLastRoll(roll.index) ? nil : .trailing,
					frame.index != 0 && roll.index == 0 ? .leading : nil,
				].compactMap { $0 },
				color: configuration.border
			)
		}
	}

	private func railView(forFrame frame: ScoredFrame) -> some View {
		Text(String(frame.index + 1))
			.font(.caption2)
			.frame(maxWidth: .infinity)
			.padding(.vertical, .unitSpacing)
			.foregroundColor(foreground(forRailInFrame: frame.index))
			.background(background(forRailInFrame: frame.index))
			.border(edges: frame.index == 0 ? [] : [.leading], color: configuration.border)
			.roundCorners(
				topLeading: configuration.roundTopRailCorners && frame.index == 0,
				topTrailing: configuration.roundTopRailCorners && Frame.isLast(frame.index),
				bottomLeading: configuration.roundBottomRailCorners && frame.index == 0,
				bottomTrailing: configuration.roundBottomRailCorners && Frame.isLast(frame.index)
			)
	}

	// MARK: - Colors

	private func foreground(forFrameIndex: Int) -> ColorAsset {
		if selection.frameIndex == forFrameIndex {
			configuration.foregroundHighlight
		} else {
			configuration.foreground
		}
	}

	private func background(forFrameIndex: Int) -> ColorAsset {
		if selection.frameIndex == forFrameIndex {
			configuration.backgroundHighlight
		} else {
			configuration.background
		}
	}

	private func foreground(
		forRollIndex: Int,
		inFrame: Int,
		didFoul: Bool,
		isSecondary: Bool
	) -> ColorAsset {
		if isSecondary {
			configuration.foregroundSecondary
		} else if selection.frameIndex == inFrame && selection.rollIndex == forRollIndex {
			if didFoul {
				configuration.foregroundFoulHighlight
			} else {
				configuration.foregroundHighlight
			}
		} else {
			if didFoul {
				configuration.foregroundFoul
			} else {
				configuration.foreground
			}
		}
	}

	private func background(forRollIndex: Int, inFrame: Int) -> ColorAsset {
		if selection.frameIndex == inFrame && selection.rollIndex == forRollIndex {
			configuration.backgroundHighlight
		} else {
			configuration.background
		}
	}

	private func foreground(forRailInFrame: Int) -> ColorAsset {
		if selection.frameIndex == forRailInFrame {
			configuration.railForegroundHighlight
		} else {
			configuration.railForeground
		}
	}

	private func background(forRailInFrame: Int) -> ColorAsset {
		if selection.frameIndex == forRailInFrame {
			configuration.railBackgroundHighlight
		} else {
			configuration.railBackground
		}
	}
}

extension ScoreSheet {
	public struct Configuration: Equatable {
		public let foreground: ColorAsset
		public let foregroundHighlight: ColorAsset
		public let foregroundSecondary: ColorAsset
		public let foregroundFoul: ColorAsset
		public let foregroundFoulHighlight: ColorAsset
		public let background: ColorAsset
		public let backgroundHighlight: ColorAsset
		public let railForeground: ColorAsset
		public let railForegroundHighlight: ColorAsset
		public let railBackground: ColorAsset
		public let railBackgroundHighlight: ColorAsset
		public let border: ColorAsset
		public let allowTopRounding: Bool
		public let allowBottomRounding: Bool
		public let railOnTop: Bool

		public init(
			foreground: ColorAsset,
			foregroundHighlight: ColorAsset,
			foregroundSecondary: ColorAsset,
			foregroundFoul: ColorAsset,
			foregroundFoulHighlight: ColorAsset,
			background: ColorAsset,
			backgroundHighlight: ColorAsset,
			railForeground: ColorAsset,
			railForegroundHighlight: ColorAsset,
			railBackground: ColorAsset,
			railBackgroundHighlight: ColorAsset,
			border: ColorAsset,
			allowTopRounding: Bool,
			allowBottomRounding: Bool,
			railOnTop: Bool
		) {
			self.foreground = foreground
			self.foregroundHighlight = foregroundHighlight
			self.foregroundSecondary = foregroundSecondary
			self.foregroundFoul = foregroundFoul
			self.foregroundFoulHighlight = foregroundFoulHighlight
			self.background = background
			self.backgroundHighlight = backgroundHighlight
			self.railForeground = railForeground
			self.railForegroundHighlight = railForegroundHighlight
			self.railBackground = railBackground
			self.railBackgroundHighlight = railBackgroundHighlight
			self.border = border
			self.allowTopRounding = allowTopRounding
			self.allowBottomRounding = allowBottomRounding
			self.railOnTop = railOnTop
		}

		var roundTopRailCorners: Bool {
			railOnTop && allowTopRounding
		}

		var roundBottomRailCorners: Bool {
			!railOnTop && allowBottomRounding
		}

		var roundTopRollCorners: Bool {
			!railOnTop && allowTopRounding
		}

		var roundBottomRollCorners: Bool {
			false
		}

		var roundTopFrameCorners: Bool {
			false
		}

		var roundBottomFrameCorners: Bool {
			railOnTop && allowBottomRounding
		}

		public static var `default`: Configuration {
			Configuration(
				foreground: Asset.Colors.ScoreSheet.Text.OnBackground.default,
				foregroundHighlight: Asset.Colors.ScoreSheet.Text.OnBackground.highlight,
				foregroundSecondary: Asset.Colors.ScoreSheet.Text.OnBackground.secondary,
				foregroundFoul: Asset.Colors.ScoreSheet.Text.OnBackground.foul,
				foregroundFoulHighlight: Asset.Colors.ScoreSheet.Text.OnBackground.highlightFoul,
				background: Asset.Colors.ScoreSheet.Background.default,
				backgroundHighlight: Asset.Colors.ScoreSheet.Background.highlight,
				railForeground: Asset.Colors.ScoreSheet.Text.OnRail.default,
				railForegroundHighlight: Asset.Colors.ScoreSheet.Text.OnRail.highlight,
				railBackground: Asset.Colors.ScoreSheet.Rail.default,
				railBackgroundHighlight: Asset.Colors.ScoreSheet.Rail.highlight,
				border: Asset.Colors.ScoreSheet.Border.default,
				allowTopRounding: true,
				allowBottomRounding: true,
				railOnTop: false
			)
		}
	}
}

#if DEBUG
struct ScoreSheetPreviews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			ScoreSheet(
				game: .init(
					id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
					index: 0,
					frames: Game.FRAME_INDICES.map {
						.init(
							index: $0,
							rolls: [
								.init(index: 0, displayValue: "HP", didFoul: true, isSecondary: false),
								.init(index: 1, displayValue: "10", didFoul: false, isSecondary: false),
								.init(index: 2, displayValue: "-", didFoul: false, isSecondary: false),
							],
							score: 255
						)
					}
				),
				configuration: .default,
				contentSize: CGSize(width: 400, height: 200),
				selection: .constant(.init(frameIndex: 0, rollIndex: 0))
			)
			Spacer()
		}
		.background(.black)
	}
}
#endif
