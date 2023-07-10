@testable import DatabaseModelsLibrary
import GRDB
@testable import ModelsLibrary
@testable import StatisticsModelsLibrary
import TestDatabaseUtilitiesLibrary
import XCTest

final class LeagueTrackableTests: XCTestCase {

	// MARK: Series

	func testTrackableSeries_ReturnsSeries() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series1 = Series.Database.mock(leagueId: UUID(0), id: UUID(0), date: Date(timeIntervalSince1970: 123), excludeFromStatistics: .include)
		let series2 = Series.Database.mock(leagueId: UUID(0), id: UUID(1), date: Date(timeIntervalSince1970: 123), excludeFromStatistics: .exclude)

		let database = try initializeDatabase(
			withLeagues: .custom([league]),
			withSeries: .custom([series1, series2])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableSeries(filter: .init()))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [series1])
	}

	func testTrackableSeries_FilteredByStartDate_ReturnsSeries() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series1 = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 1))
		let series2 = Series.Database.mock(id: UUID(1), date: Date(timeIntervalSince1970: 0))

		let database = try initializeDatabase(withLeagues: .custom([league]), withSeries: .custom([series1, series2]))

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableSeries(filter: .init(startDate: Date(timeIntervalSince1970: 1))))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [series1])
	}

	func testTrackableSeries_FilteredByEndDate_ReturnsSeries() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series1 = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 0))
		let series2 = Series.Database.mock(id: UUID(1), date: Date(timeIntervalSince1970: 1))

		let database = try initializeDatabase(withLeagues: .custom([league]), withSeries: .custom([series1, series2]))

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableSeries(filter: .init(endDate: Date(timeIntervalSince1970: 0))))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [series1])
	}

	func testTrackableSeries_FilteredByAlley_ReturnsSeries() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let alley = Alley.Database.mock(id: UUID(0), name: "Skyview")

		let series1 = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 0), alleyId: UUID(0))
		let series2 = Series.Database.mock(id: UUID(1), date: Date(timeIntervalSince1970: 1), alleyId: nil)

		let database = try initializeDatabase(withAlleys: .custom([alley]), withLeagues: .custom([league]), withSeries: .custom([series1, series2]))

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableSeries(filter: .init(alley: .alley(.init(id: UUID(0), name: "Skyview")))))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [series1])
	}

	// MARK: Games

	func testTrackableGames_ReturnsGames() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series1 = Series.Database.mock(leagueId: UUID(0), id: UUID(0), date: Date(timeIntervalSince1970: 123), excludeFromStatistics: .include)
		let series2 = Series.Database.mock(leagueId: UUID(0), id: UUID(1), date: Date(timeIntervalSince1970: 123), excludeFromStatistics: .exclude)

		let game1 = Game.Database.mock(seriesId: UUID(0), id: UUID(0), index: 0, score: 123, excludeFromStatistics: .include)
		let game2 = Game.Database.mock(seriesId: UUID(0), id: UUID(1), index: 1, score: 123, excludeFromStatistics: .exclude)
		let game3 = Game.Database.mock(seriesId: UUID(1), id: UUID(2), index: 0, score: 123, excludeFromStatistics: .include)
		let game4 = Game.Database.mock(seriesId: UUID(1), id: UUID(3), index: 1, score: 123, excludeFromStatistics: .exclude)

		let database = try initializeDatabase(
			withLeagues: .custom([league]),
			withSeries: .custom([series1, series2]),
			withGames: .custom([game1, game2, game3, game4])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableGames(
					through: League.Database.trackableSeries(filter: .init()),
					filter: .init()
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [game1])
	}

	func testTrackableGames_FilteredByOpponent_ReturnsGames() async throws {
		let bowler = Bowler.Database.mock(id: UUID(0), name: "Joseph")

		let opponent = Bowler.Database.mock(id: UUID(1), name: "Sarah")

		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 123))

		let game1 = Game.Database.mock(id: UUID(0), index: 0, score: 123)
		let game2 = Game.Database.mock(id: UUID(1), index: 1, score: 123)

		let matchPlay1 = MatchPlay.Database.mock(gameId: UUID(0), id: UUID(0), opponentId: UUID(1))
		let matchPlay2 = MatchPlay.Database.mock(gameId: UUID(1), id: UUID(1), opponentId: nil)

		let database = try initializeDatabase(
			withBowlers: .custom([bowler, opponent]),
			withLeagues: .custom([league]),
			withSeries: .custom([series]),
			withGames: .custom([game1, game2]),
			withMatchPlays: .custom([matchPlay1, matchPlay2])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableGames(
					through: League.Database.trackableSeries(filter: .init()),
					filter: .init(opponent: .init(id: UUID(1), name: "Sarah"))
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [game1])
	}

	func testTrackableGames_FilteredByGear_ReturnsGames() async throws {
		let bowler = Bowler.Database.mock(id: UUID(0), name: "Joseph")

		let opponent = Bowler.Database.mock(id: UUID(1), name: "Sarah")

		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 123))

		let game1 = Game.Database.mock(id: UUID(0), index: 0, score: 123)
		let game2 = Game.Database.mock(id: UUID(1), index: 1, score: 123)

		let gear1 = Gear.Database.mock(id: UUID(0), name: "Shoes", kind: .shoes)
		let gear2 = Gear.Database.mock(id: UUID(1), name: "Towel", kind: .towel)

		let gameGear1 = GameGear.Database(gameId: UUID(0), gearId: UUID(0))
		let gameGear2 = GameGear.Database(gameId: UUID(1), gearId: UUID(1))

		let database = try initializeDatabase(
			withBowlers: .custom([bowler, opponent]),
			withGear: .custom([gear1, gear2]),
			withLeagues: .custom([league]),
			withSeries: .custom([series]),
			withGames: .custom([game1, game2]),
			withGameGear: .custom([gameGear1, gameGear2])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableGames(
					through: League.Database.trackableSeries(filter: .init()),
					filter: .init(gearUsed: [.init(id: UUID(0), name: "Shoes")])
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [game1])
	}

	func testTrackableGames_FilteredByLaneIds_ReturnsGames() async throws {
		let bowler = Bowler.Database.mock(id: UUID(0), name: "Joseph")

		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 123))

		let game1 = Game.Database.mock(id: UUID(0), index: 0, score: 123)
		let game2 = Game.Database.mock(id: UUID(1), index: 1, score: 123)
		let game3 = Game.Database.mock(id: UUID(2), index: 2, score: 123)

		let alley = Alley.Database.mock(id: UUID(0), name: "Skyview")

		let lane1 = Lane.Database(alleyId: UUID(0), id: UUID(0), label: "1", position: .leftWall)
		let lane2 = Lane.Database(alleyId: UUID(0), id: UUID(1), label: "2", position: .rightWall)
		let lane3 = Lane.Database(alleyId: UUID(0), id: UUID(2), label: "3", position: .noWall)

		let gameLane1 = GameLane.Database(gameId: UUID(0), laneId: UUID(0))
		let gameLane2 = GameLane.Database(gameId: UUID(1), laneId: UUID(1))
		let gameLane3 = GameLane.Database(gameId: UUID(2), laneId: UUID(2))

		let database = try initializeDatabase(
			withAlleys: .custom([alley]),
			withLanes: .custom([lane1, lane2, lane3]),
			withLeagues: .custom([league]),
			withSeries: .custom([series]),
			withGames: .custom([game1, game2, game3]),
			withGameLanes: .custom([gameLane1, gameLane2, gameLane3])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableGames(
					through: League.Database.trackableSeries(filter: .init()),
					filter: .init(lanes: .lanes([.init(id: UUID(0), label: "1", position: .leftWall), .init(id: UUID(1), label: "2", position: .rightWall)]))
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [game1, game2])
	}

	func testTrackableGames_FilteredByLanePositions_ReturnsGames() async throws {
		let bowler = Bowler.Database.mock(id: UUID(0), name: "Joseph")

		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 123))

		let game1 = Game.Database.mock(id: UUID(0), index: 0, score: 123)
		let game2 = Game.Database.mock(id: UUID(1), index: 1, score: 123)
		let game3 = Game.Database.mock(id: UUID(2), index: 2, score: 123)

		let alley = Alley.Database.mock(id: UUID(0), name: "Skyview")

		let lane1 = Lane.Database(alleyId: UUID(0), id: UUID(0), label: "1", position: .leftWall)
		let lane2 = Lane.Database(alleyId: UUID(0), id: UUID(1), label: "2", position: .rightWall)
		let lane3 = Lane.Database(alleyId: UUID(0), id: UUID(2), label: "3", position: .noWall)

		let gameLane1 = GameLane.Database(gameId: UUID(0), laneId: UUID(0))
		let gameLane2 = GameLane.Database(gameId: UUID(1), laneId: UUID(1))
		let gameLane3 = GameLane.Database(gameId: UUID(2), laneId: UUID(2))

		let database = try initializeDatabase(
			withAlleys: .custom([alley]),
			withLanes: .custom([lane1, lane2, lane3]),
			withBowlers: .custom([bowler]),
			withLeagues: .custom([league]),
			withSeries: .custom([series]),
			withGames: .custom([game1, game2, game3]),
			withGameLanes: .custom([gameLane1, gameLane2, gameLane3])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableGames(
					through: League.Database.trackableSeries(filter: .init()),
					filter: .init(lanes: .positions([.leftWall, .rightWall]))
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [game1, game2])
	}

	// MARK: Frames

	func testTrackableFrames_ReturnsFrames() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series1 = Series.Database.mock(leagueId: UUID(0), id: UUID(0), date: Date(timeIntervalSince1970: 123), excludeFromStatistics: .include)
		let series2 = Series.Database.mock(leagueId: UUID(0), id: UUID(1), date: Date(timeIntervalSince1970: 123), excludeFromStatistics: .exclude)

		let game1 = Game.Database.mock(seriesId: UUID(0), id: UUID(0), index: 0, score: 123, excludeFromStatistics: .include)
		let game2 = Game.Database.mock(seriesId: UUID(0), id: UUID(1), index: 1, score: 123, excludeFromStatistics: .exclude)
		let game3 = Game.Database.mock(seriesId: UUID(1), id: UUID(2), index: 0, score: 123, excludeFromStatistics: .include)
		let game4 = Game.Database.mock(seriesId: UUID(1), id: UUID(3), index: 1, score: 123, excludeFromStatistics: .exclude)

		let frame1 = Frame.Database.mock(gameId: UUID(0), index: 0, roll0: nil, roll1: nil, roll2: nil, ball0: nil, ball1: nil, ball2: nil)
		let frame2 = Frame.Database.mock(gameId: UUID(1), index: 0, roll0: nil, roll1: nil, roll2: nil, ball0: nil, ball1: nil, ball2: nil)
		let frame3 = Frame.Database.mock(gameId: UUID(2), index: 0, roll0: nil, roll1: nil, roll2: nil, ball0: nil, ball1: nil, ball2: nil)
		let frame4 = Frame.Database.mock(gameId: UUID(3), index: 0, roll0: nil, roll1: nil, roll2: nil, ball0: nil, ball1: nil, ball2: nil)

		let database = try initializeDatabase(
			withLeagues: .custom([league]),
			withSeries: .custom([series1, series2]),
			withGames: .custom([game1, game2, game3, game4]),
			withGameGear: .zero,
			withFrames: .custom([frame1, frame2, frame3, frame4])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableFrames(
					through: League.Database.trackableGames(
						through: League.Database.trackableSeries(filter: .init()),
						filter: .init()
					),
					filter: .init()
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [frame1])
	}

	func testTrackableFrames_FilteredByGear_ReturnsFrames() async throws {
		let league = League.Database.mock(id: UUID(0), name: "Majors")

		let series = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 123))

		let game = Game.Database.mock(id: UUID(0), index: 0, score: 123)

		let ball1 = Gear.Database.mock(id: UUID(0), name: "Red", kind: .bowlingBall)
		let ball2 = Gear.Database.mock(id: UUID(1), name: "Green", kind: .bowlingBall)
		let ball3 = Gear.Database.mock(id: UUID(2), name: "Yellow", kind: .bowlingBall)

		let frame1 = Frame.Database.mock(index: 0, ball0: UUID(0))
		let frame2 = Frame.Database.mock(index: 1, ball1: UUID(1))
		let frame3 = Frame.Database.mock(index: 2, ball0: UUID(2), ball1: UUID(2), ball2: UUID(2))

		let database = try initializeDatabase(
			withGear: .custom([ball1, ball2, ball3]),
			withLeagues: .custom([league]),
			withSeries: .custom([series]),
			withGames: .custom([game]),
			withGameLanes: .zero,
			withGameGear: .zero,
			withFrames: .custom([frame1, frame2, frame3])
		)

		let result = try await database.read {
			try league
				.request(for: League.Database.trackableFrames(
					through: League.Database.trackableGames(
						through: League.Database.trackableSeries(filter: .init()),
						filter: .init()
					),
					filter: .init(bowlingBallsUsed: [.init(id: UUID(0), name: "Red"), .init(id: UUID(1), name: "Green")])
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result, [frame1, frame2])
	}

	func testTrackableFrames_WithAllFilters_ReturnsFrames() async throws {
		let bowler = Bowler.Database.mock(id: UUID(0), name: "Joseph")

		let opponent = Bowler.Database.mock(id: UUID(1), name: "Sarah", kind: .opponent)

		let league = League.Database.mock(id: UUID(0), name: "Majors", recurrence: .once)

		let alley = Alley.Database.mock(id: UUID(0), name: "Skyview")

		let lane = Lane.Database(alleyId: UUID(0), id: UUID(0), label: "1", position: .noWall)

		let series = Series.Database.mock(id: UUID(0), date: Date(timeIntervalSince1970: 123), alleyId: UUID(0))

		let game = Game.Database.mock(id: UUID(0), index: 0, score: 123)

		let ball = Gear.Database.mock(id: UUID(0), name: "Ball", kind: .bowlingBall)
		let towel = Gear.Database.mock(id: UUID(1), name: "Towel", kind: .towel)

		let gameLane = GameLane.Database(gameId: UUID(0), laneId: UUID(0))

		let gameGear = GameGear.Database(gameId: UUID(0), gearId: UUID(1))

		let frame = Frame.Database.mock(index: 0, ball0: UUID(0))

		let matchPlay = MatchPlay.Database.mock(gameId: UUID(0), id: UUID(0), opponentId: UUID(1))

		let database = try initializeDatabase(
			withAlleys: .custom([alley]),
			withLanes: .custom([lane]),
			withBowlers: .custom([bowler, opponent]),
			withGear: .custom([ball, towel]),
			withLeagues: .custom([league]),
			withSeries: .custom([series]),
			withGames: .custom([game]),
			withGameLanes: .custom([gameLane]),
			withGameGear: .custom([gameGear]),
			withFrames: .custom([frame]),
			withMatchPlays: .custom([matchPlay])
		)

		let result1 = try await database.read {
			try league
				.request(for: League.Database.trackableFrames(
					through: League.Database.trackableGames(
						through: League.Database.trackableSeries(filter: .init(startDate: Date(timeIntervalSince1970: 123), endDate: Date(timeIntervalSince1970: 123), alley: .alley(.init(id: UUID(0), name: "Skyview")))),
						filter: .init(
							lanes: .lanes([.init(id: UUID(0), label: "1", position: .noWall)]),
							gearUsed: [.init(id: UUID(1), name: "Towel")],
							opponent: .init(id: UUID(1), name: "Sarah")
						)
					),
					filter: .init(bowlingBallsUsed: [.init(id: UUID(0), name: "Ball")])
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result1, [frame])

		let result2 = try await database.read {
			try league
				.request(for: League.Database.trackableFrames(
					through: League.Database.trackableGames(
						through: League.Database.trackableSeries(filter: .init(startDate: Date(timeIntervalSince1970: 123), endDate: Date(timeIntervalSince1970: 123), alley: .alley(.init(id: UUID(0), name: "Skyview")))),
						filter: .init(
							lanes: .positions([.noWall]),
							gearUsed: [.init(id: UUID(1), name: "Towel")],
							opponent: .init(id: UUID(1), name: "Sarah")
						)
					),
					filter: .init(bowlingBallsUsed: [.init(id: UUID(0), name: "Ball")])
				))
				.fetchAll($0)
		}

		XCTAssertEqual(result2, [frame])
	}
}
