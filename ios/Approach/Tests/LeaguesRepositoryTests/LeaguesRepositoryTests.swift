import DatabaseModelsLibrary
import DatabaseServiceInterface
import Dependencies
import GRDB
@testable import LeaguesRepository
@testable import LeaguesRepositoryInterface
@testable import ModelsLibrary
import RecentlyUsedServiceInterface
import TestDatabaseUtilitiesLibrary
import TestUtilitiesLibrary
import XCTest

@MainActor
final class LeaguesRepositoryTests: XCTestCase {
	@Dependency(\.leagues) var leagues

	// MARK: - List

	func testList_ReturnsAllLeagues() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		let league2 = League.Database.mock(id: UUID(1), name: "Minors")
		let league3 = League.Database.mock(id: UUID(2), name: "Ursa", isArchived: true)

		let db = try initializeDatabase(withLeagues: .custom([league1, league2, league3]))

		// Fetching the leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the leagues
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "Majors", average: nil),
			.init(id: UUID(1), name: "Minors", average: nil),
		])
	}

	func testList_FilterByRecurrence_ReturnsMatchingLeagues() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", recurrence: .once)
		let league2 = League.Database.mock(id: UUID(1), name: "Minors", recurrence: .repeating)
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Fetching the leagues by recurrence
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), withRecurrence: .once, ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns one league
		XCTAssertEqual(fetched, [.init(id: UUID(0), name: "Majors", average: nil)])
	}

	func testList_FilterByBowler_ReturnsBowlerLeagues() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(bowlerId: UUID(0), id: UUID(0), name: "Majors")
		let league2 = League.Database.mock(bowlerId: UUID(1), id: UUID(1), name: "Minors")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Fetching the leagues by bowler
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns one league
		XCTAssertEqual(fetched, [.init(id: UUID(0), name: "Majors", average: nil)])
	}

	func testList_SortsByName() async throws {
		// Given a database with three leagues
		let league1 = League.Database.mock(id: UUID(0), name: "B League")
		let league2 = League.Database.mock(id: UUID(1), name: "A League")
		let league3 = League.Database.mock(id: UUID(2), name: "C League")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2, league3]))

		// Fetching the leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the leagues sorted by name
		XCTAssertEqual(fetched, [
			.init(id: UUID(1), name: "A League", average: nil),
			.init(id: UUID(0), name: "B League", average: nil),
			.init(id: UUID(2), name: "C League", average: nil),
		])
	}

	func testList_SortedByRecentlyUsed_SortsByRecentlyUsed() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(id: UUID(0), name: "B League")
		let league2 = League.Database.mock(id: UUID(1), name: "A League")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Given an ordering of ids
		let (recentStream, recentContinuation) = AsyncStream<[UUID]>.makeStream()
		recentContinuation.yield([UUID(0), UUID(1)])

		// Fetching the leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.recentlyUsed.observeRecentlyUsedIds = { _ in recentStream }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byRecentlyUsed)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the leagues sorted by recently used ids
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "B League", average: nil),
			.init(id: UUID(1), name: "A League", average: nil),
		])
	}

	func testList_WithGames_CalculatesAverages() async throws {
		// Given a database with 2 leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		let league2 = League.Database.mock(id: UUID(1), name: "Minors")
		// and 2 games each
		let game1 = Game.Database.mock(seriesId: UUID(0), id: UUID(0), index: 0, score: 100)
		let game2 = Game.Database.mock(seriesId: UUID(0), id: UUID(1), index: 1, score: 200)
		let game3 = Game.Database.mock(seriesId: UUID(2), id: UUID(2), index: 0, score: 250)
		let game4 = Game.Database.mock(seriesId: UUID(2), id: UUID(3), index: 1, score: 300)
		let db = try initializeDatabase(
			withLeagues: .custom([league1, league2]),
			withGames: .custom([game1, game2, game3, game4])
		)

		// Fetching the league
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns the leagues with averages
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "Majors", average: 150),
			.init(id: UUID(1), name: "Minors", average: 275),
		])
	}

	func testList_WhenSeriesExcludedFromStatistics_DoesNotIncludeInStatistics() async throws {
		// Given a database with 1 league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		// with series
		let series1 = Series.Database.mock(leagueId: UUID(0), id: UUID(0), date: Date(), excludeFromStatistics: .include)
		let series2 = Series.Database.mock(leagueId: UUID(0), id: UUID(1), date: Date(), excludeFromStatistics: .exclude)
		let series3 = Series.Database.mock(leagueId: UUID(0), id: UUID(2), date: Date(), isArchived: true)
		// and 1 game each
		let game1 = Game.Database.mock(seriesId: UUID(0), id: UUID(0), index: 0, score: 100)
		let game2 = Game.Database.mock(seriesId: UUID(1), id: UUID(1), index: 1, score: 200)
		let game3 = Game.Database.mock(seriesId: UUID(2), id: UUID(2), index: 2, score: 300)
		let db = try initializeDatabase(
			withLeagues: .custom([league1]),
			withSeries: .custom([series1, series2, series3]),
			withGames: .custom([game1, game2, game3])
		)

		// Fetching the league
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns the leagues with only one score accounted for in the average
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "Majors", average: 100),
		])
	}

	func testList_WhenGameExcludedFromStatistics_DoesNotIncludeInStatistics() async throws {
		// Given a database with 1 league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		// with series
		let series1 = Series.Database.mock(leagueId: UUID(0), id: UUID(0), date: Date())
		let series2 = Series.Database.mock(leagueId: UUID(0), id: UUID(1), date: Date())
		// and 1 game each
		let game1 = Game.Database.mock(seriesId: UUID(0), id: UUID(0), index: 0, score: 100, excludeFromStatistics: .include)
		let game2 = Game.Database.mock(seriesId: UUID(1), id: UUID(1), index: 1, score: 200, excludeFromStatistics: .exclude)
		let db = try initializeDatabase(
			withLeagues: .custom([league1]),
			withSeries: .custom([series1, series2]),
			withGames: .custom([game1, game2])
		)

		// Fetching the league
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.list(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns the league with only one score accounted for in the average
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "Majors", average: 100),
		])
	}

	// MARK: - Pickable

	func testPickable_ReturnsAllLeagues() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		let league2 = League.Database.mock(id: UUID(1), name: "Minors")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Fetching the leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.pickable(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the leagues
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "Majors"),
			.init(id: UUID(1), name: "Minors"),
		])
	}

	func testPickable_FilterByRecurrence_ReturnsMatchingLeagues() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", recurrence: .once)
		let league2 = League.Database.mock(id: UUID(1), name: "Minors", recurrence: .repeating)
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Fetching the leagues by recurrence
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.pickable(bowledBy: UUID(0), withRecurrence: .once, ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns one league
		XCTAssertEqual(fetched, [.init(id: UUID(0), name: "Majors")])
	}

	func testPickable_FilterByBowler_ReturnsBowlerLeagues() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(bowlerId: UUID(0), id: UUID(0), name: "Majors")
		let league2 = League.Database.mock(bowlerId: UUID(1), id: UUID(1), name: "Minors")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Fetching the leagues by bowler
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.pickable(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns one league
		XCTAssertEqual(fetched, [.init(id: UUID(0), name: "Majors")])
	}

	func testPickable_SortsByName() async throws {
		// Given a database with three leagues
		let league1 = League.Database.mock(id: UUID(0), name: "B League")
		let league2 = League.Database.mock(id: UUID(1), name: "A League")
		let league3 = League.Database.mock(id: UUID(2), name: "C League")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2, league3]))

		// Fetching the leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.pickable(bowledBy: UUID(0), ordering: .byName)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the leagues sorted by name
		XCTAssertEqual(fetched, [
			.init(id: UUID(1), name: "A League"),
			.init(id: UUID(0), name: "B League"),
			.init(id: UUID(2), name: "C League"),
		])
	}

	func testPickable_SortedByRecentlyUsed_SortsByRecentlyUsed() async throws {
		// Given a database with two leagues
		let league1 = League.Database.mock(id: UUID(0), name: "B League")
		let league2 = League.Database.mock(id: UUID(1), name: "A League")
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Given an ordering of ids
		let (recentStream, recentContinuation) = AsyncStream<[UUID]>.makeStream()
		recentContinuation.yield([UUID(0), UUID(1)])

		// Fetching the leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.recentlyUsed.observeRecentlyUsedIds = { _ in recentStream }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.pickable(bowledBy: UUID(0), ordering: .byRecentlyUsed)
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the leagues sorted by recently used ids
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "B League"),
			.init(id: UUID(1), name: "A League"),
		])
	}

	// MARK: Archived

	func testArchived_ReturnsArchivedLeagues() async throws {
		// Given a database with leagues
		let league1 = League.Database.mock(bowlerId: UUID(0), id: UUID(0), name: "Majors", isArchived: true)
		let league2 = League.Database.mock(bowlerId: UUID(0), id: UUID(1), name: "Minors", isArchived: false)
		// 2 series each
		let series1 = Series.Database.mock(leagueId: UUID(0), id: UUID(0), date: Date())
		let series2 = Series.Database.mock(leagueId: UUID(0), id: UUID(1), date: Date())
		let series3 = Series.Database.mock(leagueId: UUID(1), id: UUID(2), date: Date())
		let series4 = Series.Database.mock(leagueId: UUID(1), id: UUID(3), date: Date())
		// 2 games each
		let game1 = Game.Database.mock(seriesId: UUID(0), id: UUID(0), index: 0)
		let game2 = Game.Database.mock(seriesId: UUID(0), id: UUID(1), index: 0)
		let game3 = Game.Database.mock(seriesId: UUID(1), id: UUID(2), index: 0)
		let game4 = Game.Database.mock(seriesId: UUID(1), id: UUID(3), index: 0)
		let game5 = Game.Database.mock(seriesId: UUID(2), id: UUID(4), index: 0)
		let game6 = Game.Database.mock(seriesId: UUID(2), id: UUID(5), index: 0)
		let game7 = Game.Database.mock(seriesId: UUID(3), id: UUID(6), index: 0)
		let game8 = Game.Database.mock(seriesId: UUID(3), id: UUID(7), index: 0)

		let db = try initializeDatabase(
			withLeagues: .custom([league1, league2]),
			withSeries: .custom([series1, series2, series3, series4]),
			withGames: .custom([game1, game2, game3, game4, game5, game6, game7, game8])
		)

		// Fetching the archived leagues
		let leagues = withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			self.leagues.archived()
		}
		var iterator = leagues.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns the league
		XCTAssertEqual(fetched, [
			.init(id: UUID(0), name: "Majors", bowlerName: "Joseph", totalNumberOfSeries: 2, totalNumberOfGames: 4),
		])
	}

	// MARK: - Series Host

	func testSeriesHost_WhenLeagueExists_ReturnsLeague() async throws {
		// Given a database with one league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		let db = try initializeDatabase(withLeagues: .custom([league1]))

		// Fetching the league
		let league = try await withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.seriesHost(UUID(0))
		}

		// Returns the league
		XCTAssertEqual(
			league,
			.init(
				id: UUID(0),
				name: "Majors",
				numberOfGames: 4,
				alley: nil,
				excludeFromStatistics: .include
			)
		)
	}

	func testSeriesHost_WhenLeagueNotExists_ThrowsError() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withLeagues: nil)

		// Fetching the league
		await assertThrowsError(ofType: FetchableError.self) {
			try await withDependencies {
				$0.database.reader = { db }
				$0.leagues = .liveValue
			} operation: {
				_ = try await self.leagues.seriesHost(UUID(0))
			}
		}
	}

	// MARK: - Create

	func testCreate_WhenLeagueExists_ThrowsError() async throws {
		// Given a database with an existing league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", additionalPinfall: nil, additionalGames: nil)
		let db = try initializeDatabase(withLeagues: .custom([league1]))

		// Creating the league
		let new = League.Create(
			bowlerId: UUID(0),
			id: UUID(0),
			name: "Minors",
			recurrence: league1.recurrence,
			numberOfGames: league1.numberOfGames,
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: league1.excludeFromStatistics
		)
		await assertThrowsError(ofType: DatabaseError.self) {
			try await withDependencies {
				$0.database.writer = { db }
				$0.leagues = .liveValue
			} operation: {
				try await self.leagues.create(new)
			}
		}

		// Does not update the database
		let updated = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(updated?.id, UUID(0))
		XCTAssertEqual(updated?.name, "Majors")

		// Does not insert any records
		let count = try await db.read { try League.Database.fetchCount($0) }
		XCTAssertEqual(count, 1)
	}

	func testCreate_WhenLeagueNotExists_CreatesLeague() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withAlleys: .default, withBowlers: .default, withLeagues: nil)

		// Creating a league
		let new = League.Create(
			bowlerId: UUID(0),
			id: UUID(0),
			name: "Minors",
			recurrence: .once,
			numberOfGames: 1,
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: .exclude
		)
		try await withDependencies {
			$0.database.writer = { db }
			$0.uuid = .incrementing
			$0.date = .constant(Date(timeIntervalSince1970: 123_456_000))
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.create(new)
		}

		// Inserted the record
		let exists = try await db.read { try League.Database.exists($0, id: UUID(0)) }
		XCTAssertTrue(exists)

		// Updates the database
		let created = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(created?.id, UUID(0))
		XCTAssertEqual(created?.name, "Minors")
		XCTAssertEqual(created?.numberOfGames, 1)
	}

	func testCreate_WhenLeagueRepeats_DoesNotCreateGames() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withAlleys: .default, withBowlers: .default, withLeagues: nil)

		// Creating a league
		let new = League.Create(
			bowlerId: UUID(0),
			id: UUID(0),
			name: "Minors",
			recurrence: .repeating,
			numberOfGames: 1,
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: .exclude
		)
		try await withDependencies {
			$0.database.writer = { db }
			$0.uuid = .incrementing
			$0.date = .constant(Date(timeIntervalSince1970: 123_456_000))
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.create(new)
		}

		// Does not insert any series, games, or frames
		let numberOfSeries = try await db.read { try Series.Database.fetchCount($0) }
		XCTAssertEqual(numberOfSeries, 0)

		let numberOfGames = try await db.read { try Game.Database.fetchCount($0) }
		XCTAssertEqual(numberOfGames, 0)

		let numberOfFrames = try await db.read { try Frame.Database.fetchCount($0) }
		XCTAssertEqual(numberOfFrames, 0)
	}

	func testCreate_WhenLeagueRepeats_WithPreferredGear_InsertsGear() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withAlleys: .default, withBowlers: .default, withGear: .default, withLeagues: nil, withBowlerPreferredGear: .default)

		// Creating a league
		let new = League.Create(
			bowlerId: UUID(0),
			id: UUID(0),
			name: "Minors",
			recurrence: .once,
			numberOfGames: 1,
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: .exclude
		)
		try await withDependencies {
			$0.database.writer = { db }
			$0.uuid = .incrementing
			$0.date = .constant(Date(timeIntervalSince1970: 123_456_000))
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.create(new)
		}

		// Inserts game gear
		let numberOfGameGear = try await db.read { try GameGear.Database.fetchCount($0) }
		XCTAssertEqual(numberOfGameGear, 2)
	}

	func testCreate_WhenLeagueDoesNotRepeat_CreatesGames() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withAlleys: .default, withBowlers: .default, withLeagues: nil)

		// Creating a league
		let new = League.Create(
			bowlerId: UUID(0),
			id: UUID(0),
			name: "Minors",
			recurrence: .once,
			numberOfGames: 2,
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: .exclude
		)
		try await withDependencies {
			$0.database.writer = { db }
			$0.uuid = .incrementing
			$0.date = .constant(Date(timeIntervalSince1970: 123_456_000))
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.create(new)
		}

		// Inserts series, games, and frames
		let numberOfSeries = try await db.read { try Series.Database.fetchCount($0) }
		XCTAssertEqual(numberOfSeries, 1)

		let numberOfGames = try await db.read { try Game.Database.fetchCount($0) }
		XCTAssertEqual(numberOfGames, 2)

		let numberOfFrames = try await db.read { try Frame.Database.fetchCount($0) }
		XCTAssertEqual(numberOfFrames, 20)
	}

	// MARK: - Update

	func testUpdate_WhenLeagueExists_UpdatesLeague() async throws {
		// Given a database with an existing league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", additionalPinfall: nil, additionalGames: nil)
		let db = try initializeDatabase(withLeagues: .custom([league1]))

		// Editing the league
		let existing = League.Edit(
			id: UUID(0),
			recurrence: .repeating,
			numberOfGames: 4,
			name: "Minors",
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: league1.excludeFromStatistics
		)
		try await withDependencies {
			$0.database.writer = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.update(existing)
		}

		// Updates the database
		let updated = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(updated?.id, UUID(0))
		XCTAssertEqual(updated?.name, "Minors")

		// Does not insert any records
		let count = try await db.read { try League.Database.fetchCount($0) }
		XCTAssertEqual(count, 1)
	}

	func testUpdate_WhenLeagueNotExists_ThrowsError() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withLeagues: nil)

		// Editing a league
		let existing = League.Edit(
			id: UUID(0),
			recurrence: .once,
			numberOfGames: 1,
			name: "Minors",
			additionalPinfall: 123,
			additionalGames: 123,
			excludeFromStatistics: .exclude
		)
		await assertThrowsError(ofType: RecordError.self) {
			try await withDependencies {
				$0.database.writer = { db }
				$0.leagues = .liveValue
			} operation: {
				try await self.leagues.update(existing)
			}
		}

		// Does not insert the record
		let exists = try await db.read { try League.Database.exists($0, id: UUID(0)) }
		XCTAssertFalse(exists)

		// Does not insert any records
		let count = try await db.read { try League.Database.fetchCount($0) }
		XCTAssertEqual(count, 0)
	}

	// MARK: - Edit

	func testEdit_WhenLeagueExists_ReturnsLeague() async throws {
		// Given a database with one league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors")
		let db = try initializeDatabase(withLeagues: .custom([league1]))

		// Editing the league
		let league = try await withDependencies {
			$0.database.reader = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.edit(UUID(0))
		}

		// Returns the league
		XCTAssertEqual(
			league,
			.init(
				id: UUID(0),
				recurrence: .repeating,
				numberOfGames: 4,
				name: "Majors",
				additionalPinfall: nil,
				additionalGames: nil,
				excludeFromStatistics: .include
			)
		)
	}

	func testEdit_WhenLeagueNotExists_ThrowsError() async throws {
		// Given a database with no leagues
		let db = try initializeDatabase(withLeagues: nil)

		// Editing the league
		await assertThrowsError(ofType: FetchableError.self) {
			try await withDependencies {
				$0.database.reader = { db }
				$0.leagues = .liveValue
			} operation: {
				_ = try await self.leagues.edit(UUID(0))
			}
		}
	}

	// MARK: Archive

	func testArchive_WhenIdExists_ArchivesLeague() async throws {
		// Given a database with 2 leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", isArchived: false)
		let league2 = League.Database.mock(id: UUID(1), name: "Minors", isArchived: false)
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Archiving the first league
		try await withDependencies {
			$0.database.writer = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.archive(UUID(0))
		}

		// Does not delete the entry
		let archiveExists = try await db.read { try League.Database.exists($0, id: UUID(0)) }
		XCTAssertTrue(archiveExists)

		// Marks the entry as archived
		let archived = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(archived?.isArchived, true)

		// And leaves the other league intact
		let otherExists = try await db.read { try League.Database.exists($0, id: UUID(1)) }
		XCTAssertTrue(otherExists)
		let otherIsArchived = try await db.read { try League.Database.fetchOne($0, id: UUID(1)) }
		XCTAssertEqual(otherIsArchived?.isArchived, false)
	}

	func testArchive_WhenIdNotExists_DoesNothing() async throws {
		// Given a database with 1 league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", isArchived: false)
		let db = try initializeDatabase(withLeagues: .custom([league1]))

		// Archiving a non-existent league
		try await withDependencies {
			$0.database.writer = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.archive(UUID(1))
		}

		// Leaves the league
		let exists = try await db.read { try League.Database.exists($0, id: UUID(0)) }
		XCTAssertTrue(exists)
		let archived = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(archived?.isArchived, false)
	}

	// MARK: Unarchive

	func testUnarchive_WhenIdExists_UnarchivesLeague() async throws {
		// Given a database with 2 leagues
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", isArchived: true)
		let league2 = League.Database.mock(id: UUID(1), name: "Minors", isArchived: true)
		let db = try initializeDatabase(withLeagues: .custom([league1, league2]))

		// Unarchiving the first league
		try await withDependencies {
			$0.database.writer = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.unarchive(UUID(0))
		}

		// Does not delete the entry
		let archiveExists = try await db.read { try League.Database.exists($0, id: UUID(0)) }
		XCTAssertTrue(archiveExists)

		// Marks the entry as unarchived
		let archived = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(archived?.isArchived, false)

		// And leaves the other league intact
		let otherExists = try await db.read { try League.Database.exists($0, id: UUID(1)) }
		XCTAssertTrue(otherExists)
		let otherIsArchived = try await db.read { try League.Database.fetchOne($0, id: UUID(1)) }
		XCTAssertEqual(otherIsArchived?.isArchived, true)
	}

	func testUnarchive_WhenIdNotExists_DoesNothing() async throws {
		// Given a database with 1 league
		let league1 = League.Database.mock(id: UUID(0), name: "Majors", isArchived: false)
		let db = try initializeDatabase(withLeagues: .custom([league1]))

		// Unarchiving a non-existent league
		try await withDependencies {
			$0.database.writer = { db }
			$0.leagues = .liveValue
		} operation: {
			try await self.leagues.unarchive(UUID(1))
		}

		// Leaves the league
		let exists = try await db.read { try League.Database.exists($0, id: UUID(0)) }
		XCTAssertTrue(exists)
		let archived = try await db.read { try League.Database.fetchOne($0, id: UUID(0)) }
		XCTAssertEqual(archived?.isArchived, false)
	}
}
