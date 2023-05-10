public enum Frame {}

extension Frame {
	public static let NUMBER_OF_ROLLS = 3
	public static let ROLL_INDICES = 0..<NUMBER_OF_ROLLS

	public static func isLast(_ index: Int) -> Bool {
		index == Game.NUMBER_OF_FRAMES - 1
	}

	public static func rollIndices(after: Int) -> Range<Int> {
		(after + 1)..<NUMBER_OF_ROLLS
	}
}

extension Frame.Roll {
	public static let FOUL_PENALTY = 15

	public static func isLast(_ index: Int) -> Bool {
		index == Frame.NUMBER_OF_ROLLS - 1
	}
}

extension Frame {
	public struct Roll: Sendable, Equatable, Codable {
		public var pinsDowned: Set<Pin>
		public var didFoul: Bool

		public init(pinsDowned: Set<Pin>, didFoul: Bool) {
			self.pinsDowned = pinsDowned
			self.didFoul = didFoul
		}

		public init(from bitString: String) {
			assert(bitString.count == 6)
			self.didFoul = bitString.first != "0"
			self.pinsDowned = Set(bitString.dropFirst().enumerated().compactMap { index, bit in
				bit == "0" ? nil : Pin(rawValue: index)
			})
		}

		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()
			let bitString = try container.decode(String.self)
			self.init(from: bitString)
		}

		public func encode(to encoder: Encoder) throws {
			let bools = [didFoul] + Pin.fullDeck.map { pinsDowned.contains($0) }
			let bitString = bools.map { $0 ? "1" : "0" }.joined()
			var container = encoder.singleValueContainer()
			try container.encode(bitString)
		}

		public static let `default` = Self(pinsDowned: [], didFoul: false)
	}

	public struct OrderedRoll: Sendable, Identifiable, Equatable {
		public let index: Int
		public var roll: Roll
		public var bowlingBall: Gear.Rolled?

		public var id: Int { index }

		public init(index: Int, roll: Roll, bowlingBall: Gear.Rolled?) {
			self.index = index
			self.roll = roll
			self.bowlingBall = bowlingBall
		}

		public var displayValue: String {
			roll.pinsDowned.displayValue(rollIndex: index)
		}
	}
}
