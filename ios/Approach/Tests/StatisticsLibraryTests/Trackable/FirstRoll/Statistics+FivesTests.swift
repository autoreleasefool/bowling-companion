import Dependencies
import ModelsLibrary
@testable import StatisticsLibrary
import XCTest

final class FivesTests: XCTestCase {
	func testAdjust_ByFramesWithFives_Adjusts() {
		let statistic = create(
			statistic: Statistics.Fives.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.rightThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin])),
					]
				),
				Frame.TrackableEntry(
					index: 2,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.leftThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.rightTwoPin, .rightThreePin])),
					]
				),
				Frame.TrackableEntry(
					index: 3,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 4,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 4,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
			],
			withFrameConfiguration: .default
		)

		AssertCounting(statistic, equals: 2)
	}

	func testAdjust_ByFramesWithoutFives_DoesNotAdjust() {
		let statistic = create(
			statistic: Statistics.Fives.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [])),
						.init(index: 1, roll: .init(pinsDowned: [.rightTwoPin, .rightThreePin])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin])),
					]
				),
				Frame.TrackableEntry(
					index: 2,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.rightThreePin, .leftTwoPin])),
					]
				),
			],
			withFrameConfiguration: .default
		)

		AssertCounting(statistic, equals: 0)
	}

	func testAdjustBySeries_DoesNothing() {
		let statistic = create(statistic: Statistics.Fives.self, adjustedBySeries: Series.TrackableEntry.mocks)
		AssertCounting(statistic, equals: 0)
	}

	func testAdjustByGame_DoesNothing() {
		let statistic = create(statistic: Statistics.Fives.self, adjustedByGames: Game.TrackableEntry.mocks)
		AssertCounting(statistic, equals: 0)
	}
}
