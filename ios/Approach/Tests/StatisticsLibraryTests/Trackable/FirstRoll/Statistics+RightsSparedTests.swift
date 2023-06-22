import Dependencies
import ModelsLibrary
@testable import StatisticsLibrary
import XCTest

final class RightsSparedTests: XCTestCase {
	func testAdjust_ByFramesWithRightsSpared_Adjusts() {
		let statistic = create(
			statistic: Statistics.RightsSpared.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.rightThreePin, .headPin, .leftThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.rightThreePin, .headPin, .leftThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
						.init(index: 2, roll: .init(pinsDowned: [.rightTwoPin])),
					]
				),
			],
			withFrameConfiguration: .init(countHeadPin2AsHeadPin: false)
		)

		AssertPercentage(statistic, hasNumerator: 1, withDenominator: 2, formattedAs: "50%")
	}

	func testAdjust_ByFramesWithoutLeftsSpared_DoesNotAdjust() {
		let statistic = create(
			statistic: Statistics.RightsSpared.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.rightThreePin, .headPin, .leftThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.rightThreePin, .headPin, .leftThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
						.init(index: 2, roll: .init(pinsDowned: [.rightTwoPin])),
					]
				),
			],
			withFrameConfiguration: .init(countHeadPin2AsHeadPin: false)
		)

		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 2, formattedAs: "0%")
	}

	func testAdjustBySeries_DoesNothing() {
		let statistic = create(statistic: Statistics.RightsSpared.self, adjustedBySeries: Series.TrackableEntry.mocks)
		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 0, formattedAs: "0%")
	}

	func testAdjustByGame_DoesNothing() {
		let statistic = create(statistic: Statistics.RightsSpared.self, adjustedByGames: Game.TrackableEntry.mocks)
		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 0, formattedAs: "0%")
	}
}