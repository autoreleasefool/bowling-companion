import Dependencies
import ModelsLibrary
@testable import StatisticsLibrary
import XCTest

final class LeftSplitsSparedTests: XCTestCase {
	func testAdjust_ByFramesWithLeftSplitsSpared_Adjusts() {
		let statistic = create(
			statistic: Statistics.LeftSplitsSpared.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 2,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin, .rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 3,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 4,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin])),
					]
				),
				Frame.TrackableEntry(
					index: 5,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin, .rightTwoPin])),
					]
				),
			],
			withFrameConfiguration: .default
		)

		AssertPercentage(statistic, hasNumerator: 2, withDenominator: 3, formattedAs: "66.7% (2)")
	}

	func testAdjust_ByFramesWithoutLeftSplitsSpared_DoesNotAdjust() {
		let statistic = create(
			statistic: Statistics.LeftSplitsSpared.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin])),
						.init(index: 2, roll: .init(pinsDowned: [.rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 2,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 3,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 4,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin])),
					]
				),
				Frame.TrackableEntry(
					index: 5,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .rightTwoPin])),
					]
				),
			],
			withFrameConfiguration: .default
		)

		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 2, formattedAs: "0%", overridingIsEmptyExpectation: true)
	}

	func testAdjust_ByFramesWithLeftSplitsWithBonusSpared_WithBonusEnabled_Adjusts() {
		let statistic = create(
			statistic: Statistics.LeftSplitsSpared.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftThreePin, .rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 2,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin])),
					]
				),
				Frame.TrackableEntry(
					index: 3,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 4,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin])),
					]
				),
				Frame.TrackableEntry(
					index: 5,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
			],
			withFrameConfiguration: .init(countHeadPin2AsHeadPin: false, countSplitWithBonusAsSplit: true)
		)

		AssertPercentage(statistic, hasNumerator: 1, withDenominator: 3, formattedAs: "33.3% (1)")
	}

	func testAdjust_ByFramesWithLeftSplitsWithBonusSpared_WithBonusDisabled_DoesNotAdjust() {
		let statistic = create(
			statistic: Statistics.LeftSplitsSpared.self,
			adjustedByFrames: [
				Frame.TrackableEntry(
					index: 0,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftThreePin, .rightTwoPin])),
					]
				),
				Frame.TrackableEntry(
					index: 1,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .rightThreePin, .leftTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 2,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin])),
					]
				),
				Frame.TrackableEntry(
					index: 3,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin, .leftThreePin, .rightTwoPin])),
						.init(index: 1, roll: .init(pinsDowned: [])),
					]
				),
				Frame.TrackableEntry(
					index: 4,
					rolls: [
						.init(index: 0, roll: .init(pinsDowned: [.headPin])),
					]
				),
			],
			withFrameConfiguration: .init(countHeadPin2AsHeadPin: false, countSplitWithBonusAsSplit: false)
		)

		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 0, formattedAs: "0%")
	}

	func testAdjust_InLastFrame_ByFramesWithLeftSplitsSpared_Adjusts() {
			let statistic = create(
				statistic: Statistics.LeftSplitsSpared.self,
				adjustedByFrames: [
					// Open attempt
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftThreePin, .headPin])),
							.init(index: 1, roll: .init(pinsDowned: [.rightTwoPin, .rightThreePin])),
							.init(index: 2, roll: .init(pinsDowned: [.leftTwoPin])),
						]
					),
					// Spared attempt, followed by strike
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftThreePin, .headPin])),
							.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightTwoPin, .rightThreePin])),
							.init(index: 2, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
						]
					),
					// Spared attempt, followed by open
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftThreePin, .headPin])),
							.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .rightTwoPin, .rightThreePin])),
							.init(index: 2, roll: .init(pinsDowned: [])),
						]
					),
					// Strike, followed by spared attempt
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
							.init(index: 1, roll: .init(pinsDowned: [.leftThreePin, .headPin, .rightTwoPin])),
							.init(index: 2, roll: .init(pinsDowned: [.leftTwoPin, .rightThreePin])),
						]
					),
					// Strike followed by open attempt
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
							.init(index: 1, roll: .init(pinsDowned: [.leftThreePin, .headPin])),
							.init(index: 2, roll: .init(pinsDowned: [])),
						]
					),
					// Two strikes, followed by spareable shot
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
							.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
							.init(index: 2, roll: .init(pinsDowned: [.leftThreePin, .headPin])),
						]
					),
					// Three strikes
					Frame.TrackableEntry(
						index: Game.NUMBER_OF_FRAMES - 1,
						rolls: [
							.init(index: 0, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
							.init(index: 1, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
							.init(index: 2, roll: .init(pinsDowned: [.leftTwoPin, .leftThreePin, .headPin, .rightThreePin, .rightTwoPin])),
						]
					),
				],
				withFrameConfiguration: .init(countHeadPin2AsHeadPin: false, countSplitWithBonusAsSplit: true)
			)

			AssertPercentage(statistic, hasNumerator: 3, withDenominator: 5, formattedAs: "60% (3)")
		}

	func testAdjustBySeries_DoesNothing() {
		let statistic = create(statistic: Statistics.LeftSplitsSpared.self, adjustedBySeries: Series.TrackableEntry.mocks)
		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 0, formattedAs: "0%")
	}

	func testAdjustByGame_DoesNothing() {
		let statistic = create(statistic: Statistics.LeftSplitsSpared.self, adjustedByGames: Game.TrackableEntry.mocks)
		AssertPercentage(statistic, hasNumerator: 0, withDenominator: 0, formattedAs: "0%")
	}
}
