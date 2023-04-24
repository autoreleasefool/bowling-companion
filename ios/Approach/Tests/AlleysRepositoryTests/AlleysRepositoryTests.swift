@testable import AlleysRepository
@testable import AlleysRepositoryInterface
import DatabaseModelsLibrary
@testable import DatabaseService
import Dependencies
import GRDB
@testable import LanesRepositoryInterface
@testable import ModelsLibrary
import RecentlyUsedServiceInterface
import TestUtilitiesLibrary
import XCTest

@MainActor
final class AlleysRepositoryTests: XCTestCase {

	let laneId1 = UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!
	let laneId2 = UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!

	let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
	let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
	let id3 = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!

	// MARK: - List

	func testList_ReturnsAllAlleys() async throws {
		// Given a database with two alleys
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview", material: .wood)
		let alley2 = Alley.Database.mock(id: id2, name: "Skyview", mechanism: .dedicated)
		let db = try await initializeDatabase(inserting: [alley1, alley2])

		// Fetching the alleys
		let alleys = withDependencies {
			$0.database.reader = { db }
		} operation: {
			AlleysRepository.liveValue.list(ordered: .byName)
		}
		var iterator = alleys.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the alleys
		XCTAssertEqual(fetched, [.init(alley1), .init(alley2)])
	}

	func testList_FilterByProperty_ReturnsOneAlley() async throws {
		// Given a database with two alleys
		let alley1 = Alley.Database.mock(id: id1, name: "Skyview", material: .wood)
		let alley2 = Alley.Database.mock(id: id2, name: "Grandview", mechanism: .dedicated)
		let db = try await initializeDatabase(inserting: [alley1, alley2])

		// Fetching the alleys by wood material
		let alleys = withDependencies {
			$0.database.reader = { db }
		} operation: {
			AlleysRepository.liveValue.filteredList(withMaterial: .wood, ordered: .byName)
		}
		var iterator = alleys.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns one alley
		XCTAssertEqual(fetched, [.init(alley1)])
	}

	func testList_FilterByMultipleProperties_ReturnsNone() async throws {
		// Given a database with two alleys
		let alley1 = Alley.Database.mock(id: id1, name: "Skyview", material: .wood)
		let alley2 = Alley.Database.mock(id: id2, name: "Grandview", mechanism: .dedicated)
		let alley3 = Alley.Database.mock(id: id3, name: "Commodore", pinFall: .freefall)
		let db = try await initializeDatabase(inserting: [alley1, alley2, alley3])

		// Fetching the alleys by wood material and freefall
		let alleys = withDependencies {
			$0.database.reader = { db }
		} operation: {
			AlleysRepository.liveValue.filteredList(withMaterial: .wood, withPinFall: .freefall, ordered: .byName)
		}
		var iterator = alleys.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns no alleys
		XCTAssertEqual(fetched, [])
	}

	func testList_SortsByName() async throws {
		// Given a database with three alleys
		let alley1 = Alley.Database.mock(id: id1, name: "Skyview", material: .wood)
		let alley2 = Alley.Database.mock(id: id2, name: "Grandview", mechanism: .dedicated)
		let db = try await initializeDatabase(inserting: [alley1, alley2])

		// Fetching the alleys
		let alleys = withDependencies {
			$0.database.reader = { db }
		} operation: {
			AlleysRepository.liveValue.list(ordered: .byName)
		}
		var iterator = alleys.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the alleys
		XCTAssertEqual(fetched, [.init(alley2), .init(alley1)])
	}

	func testList_SortedByRecentlyUsed_SortsByRecentlyUsed() async throws {
		// Given a database with two alleys
		let alley1 = Alley.Database.mock(id: id1, name: "Skyview", material: .wood)
		let alley2 = Alley.Database.mock(id: id2, name: "Grandview", mechanism: .dedicated)
		let db = try await initializeDatabase(inserting: [alley1, alley2])

		// Given an ordering of ids
		let (recentStream, recentContinuation) = AsyncStream<[UUID]>.streamWithContinuation()
		recentContinuation.yield([id1, id2])

		// Fetching the alleys
		let alleys = withDependencies {
			$0.database.reader = { db }
			$0.recentlyUsedService.observeRecentlyUsedIds = { _ in recentStream }
		} operation: {
			AlleysRepository.liveValue.list(ordered: .byRecentlyUsed)
		}
		var iterator = alleys.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns all the alleys sorted by recently used ids
		XCTAssertEqual(fetched, [.init(alley1), .init(alley2)])
	}

	// MARK: - Load

	func testLoad_WhenAlleyExists_ReturnsAlley() async throws {
		// Given a database with one alley
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview", material: .wood)
		let db = try await initializeDatabase(inserting: [alley1])

		// Fetching the alleys
		let alley = withDependencies {
			$0.database.reader = { db }
		} operation: {
			AlleysRepository.liveValue.load(id1)
		}
		var iterator = alley.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns the alley
		XCTAssertEqual(fetched, .init(alley1))
	}

	func testLoad_WhenAlleyNotExists_ReturnsNil() async throws {
		// Given a database with no alleys
		let db = try await initializeDatabase(inserting: [])

		// Fetching the alleys
		let alley = withDependencies {
			$0.database.reader = { db }
		} operation: {
			AlleysRepository.liveValue.load(id1)
		}
		var iterator = alley.makeAsyncIterator()
		let fetched = try await iterator.next()

		// Returns nil
		XCTAssertNil(fetched)
	}

	// MARK: - Create

	func testCreate_WhenAlleyExists_ThrowsError() async throws {
		// Given a database with an existing alley
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview")
		let db = try await initializeDatabase(inserting: [alley1])

		// Creating the alley
		let new = Alley.Create(
			id: id1,
			name: "Skyview Lanes",
			address: nil,
			material: .wood,
			pinFall: nil,
			mechanism: nil,
			pinBase: nil
		)
		await assertThrowsError(ofType: DatabaseError.self) {
			try await withDependencies {
				$0.database.writer = { db }
			} operation: {
				try await AlleysRepository.liveValue.create(new)
			}
		}

		// Does not insert any records
		let count = try await db.read { try Alley.Database.fetchCount($0) }
		XCTAssertEqual(count, 1)

		// Does not update the existing alley
		let existing = try await db.read { try Alley.Database.fetchOne($0, id: self.id1) }
		XCTAssertEqual(existing?.id, id1)
		XCTAssertEqual(existing?.name, "Grandview")
		XCTAssertNil(existing?.material)
	}

	func testCreate_WhenAlleyNotExists_CreatesAlley() async throws {
		// Given a database with no alleys
		let db = try await initializeDatabase()

		// Creating the alley
		let new = Alley.Create(
			id: id1,
			name: "Skyview Lanes",
			address: nil,
			material: .wood,
			pinFall: nil,
			mechanism: nil,
			pinBase: nil
		)
		try await withDependencies {
			$0.database.writer = { db }
		} operation: {
			try await AlleysRepository.liveValue.create(new)
		}

		// Inserts the alley
		let count = try await db.read { try Alley.Database.fetchCount($0) }
		XCTAssertEqual(count, 1)

		// Updates the database
		let created = try await db.read { try Alley.Database.fetchOne($0, id: self.id1) }
		XCTAssertEqual(created?.id, id1)
		XCTAssertEqual(created?.name, "Skyview Lanes")
	}

	// MARK: - Update

	func testUpdate_WhenAlleyExists_UpdatesAlley() async throws {
		// Given a database with an existing alley
		let alley1 = Alley.Database.mock(id: id1, name: "Skyview")
		let db = try await initializeDatabase(inserting: [alley1])

		// Editing the alley
		let editable = Alley.Edit(
			id: id1,
			name: "Skyview Lanes",
			address: nil,
			material: .wood,
			pinFall: nil,
			mechanism: nil,
			pinBase: nil
		)
		try await withDependencies {
			$0.database.writer = { db }
		} operation: {
			try await AlleysRepository.liveValue.update(editable)
		}

		// Updates the database
		let updated = try await db.read { try Alley.Database.fetchOne($0, id: self.id1) }
		XCTAssertEqual(updated?.id, id1)
		XCTAssertEqual(updated?.name, "Skyview Lanes")
		XCTAssertNil(updated?.address)
		XCTAssertEqual(updated?.material, .wood)

		// Does not insert any records
		let count = try await db.read { try Alley.Database.fetchCount($0) }
		XCTAssertEqual(count, 1)
	}

	func testUpdate_WhenAlleyNotExists_ThrowsError() async throws {
		// Given a database with no alleys
		let db = try await initializeDatabase(inserting: [])

		// Saving an alley
		let editable = Alley.Edit(
			id: id1,
			name: "Skyview Lanes",
			address: nil,
			material: .wood,
			pinFall: nil,
			mechanism: nil,
			pinBase: nil
		)
		await assertThrowsError(ofType: RecordError.self) {
			try await withDependencies {
				$0.database.writer = { db }
			} operation: {
				try await AlleysRepository.liveValue.update(editable)
			}
		}

		// Does not insert any records
		let count = try await db.read { try Alley.Database.fetchCount($0) }
		XCTAssertEqual(count, 0)
	}

	// MARK: - Edit

	func testEdit_WhenAlleyExists_ReturnsAlley() async throws {
		// Given a database with one alley
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview", material: .wood)
		let db = try await initializeDatabase(inserting: [alley1])

		// Editing the alley
		let alley = try await withDependencies {
			$0.database.reader = { db }
		} operation: {
			try await AlleysRepository.liveValue.edit(id1)
		}

		// Returns the alley
		XCTAssertEqual(
			alley,
			.init(
				alley: .init(
					id: id1,
					name: "Grandview",
					address: nil,
					material: .wood,
					pinFall: nil,
					mechanism: nil,
					pinBase: nil
				),
				lanes: []
			)
		)
	}

	func testEdit_WhenAlleyExistsWithLanes_ReturnsAlleyWithLanes() async throws {
		// Given a database with one alley
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview", material: .wood)
		let db = try await initializeDatabase(inserting: [alley1])

		let lanes = [
			Lane.Database(alleyId: id1, id: laneId1, label: "1", position: .leftWall),
			Lane.Database(alleyId: id1, id: laneId2, label: "2", position: .noWall),
		]
		try await db.write {
			for lane in lanes {
				try lane.insert($0)
			}
		}

		// Editing the alley
		let alley = try await withDependencies {
			$0.database.reader = { db }
		} operation: {
			try await AlleysRepository.liveValue.edit(id1)
		}

		// Returns the alley
		XCTAssertEqual(
			alley,
			.init(
				alley: .init(
					id: id1,
					name: "Grandview",
					address: nil,
					material: .wood,
					pinFall: nil,
					mechanism: nil,
					pinBase: nil
				),
				lanes: [
					.init(id: laneId1, label: "1", position: .leftWall),
					.init(id: laneId2, label: "2", position: .noWall),
				]
			)
		)
	}

	func testEdit_WhenAlleyNotExists_ReturnsNil() async throws {
		// Given a database with no alleys
		let db = try await initializeDatabase(inserting: [])

		// Editing the alley
		let alley = try await withDependencies {
			$0.database.reader = { db }
		} operation: {
			try await AlleysRepository.liveValue.edit(id1)
		}

		// Returns nil
		XCTAssertNil(alley)
	}

	// MARK: - Delete

	func testDelete_WhenIdExists_DeletesAlley() async throws {
		// Given a database with 2 alleys
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview", material: .wood)
		let alley2 = Alley.Database.mock(id: id2, name: "Skyview", mechanism: .dedicated)
		let db = try await initializeDatabase(inserting: [alley1, alley2])

		// Deleting the first alley
		try await withDependencies {
			$0.database.writer = { db }
		} operation: {
			try await AlleysRepository.liveValue.delete(self.id1)
		}

		// Updates the database
		let deletedExists = try await db.read { try Alley.Database.exists($0, id: self.id1) }
		XCTAssertFalse(deletedExists)

		// And leaves the other alley intact
		let otherExists = try await db.read { try Alley.Database.exists($0, id: self.id2) }
		XCTAssertTrue(otherExists)
	}

	func testDelete_WhenIdNotExists_DoesNothing() async throws {
		// Given a database with 1 alley
		let alley1 = Alley.Database.mock(id: id1, name: "Grandview", material: .wood)
		let db = try await initializeDatabase(inserting: [alley1])

		// Deleting a non-existent alley
		try await withDependencies {
			$0.database.writer = { db }
		} operation: {
			try await AlleysRepository.liveValue.delete(self.id2)
		}

		// Leaves the alley
		let exists = try await db.read { try Alley.Database.exists($0, id: self.id1) }
		XCTAssertTrue(exists)
	}

	private func initializeDatabase(
		inserting alleys: [Alley.Database] = []
	) async throws -> any DatabaseWriter {
		let dbQueue = try DatabaseQueue()
		var migrator = DatabaseMigrator()
		migrator.registerDBMigrations()
		try migrator.migrate(dbQueue)

		try await dbQueue.write {
			for alley in alleys {
				try alley.insert($0)
			}
		}

		return dbQueue
	}
}

extension Alley.Database {
	static func mock(
		id: ID,
		name: String,
		address: String? = nil,
		material: Alley.Material? = nil,
		pinFall: Alley.PinFall? = nil,
		mechanism: Alley.Mechanism? = nil,
		pinBase: Alley.PinBase? = nil
	) -> Self {
		.init(
			id: id,
			name: name,
			address: address,
			material: material,
			pinFall: pinFall,
			mechanism: mechanism,
			pinBase: pinBase
		)
	}
}

extension Alley.Summary {
	init(_ from: Alley.Database) {
		self.init(
			id: from.id,
			name: from.name,
			address: from.address,
			material: from.material,
			pinFall: from.pinFall,
			mechanism: from.mechanism,
			pinBase: from.pinBase
		)
	}
}
