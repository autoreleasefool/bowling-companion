import ComposableArchitecture
import Dependencies
@testable import OpponentsDataProvider
@testable import OpponentsDataProviderInterface
import PersistenceServiceInterface
import RecentlyUsedServiceInterface
import SharedModelsLibrary
import SharedModelsMocksLibrary
import XCTest

final class OpponentsDataProviderTests: XCTestCase {
	func testFetchOpponents_ByRecentlyUsed_SortsByNameWhenNoRecentlyUsed() async throws {
		let id0 = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
		let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

		let opponent1: Opponent = .mock(id: id0, name: "first")
		let opponent2: Opponent = .mock(id: id1, name: "second")
		let opponent3: Opponent = .mock(id: id2, name: "third")

		try await withDependencies {
			$0.persistenceService.fetchOpponents = { _ in
				return [opponent1, opponent2, opponent3]
			}
			$0.recentlyUsedService.getRecentlyUsed = { category in
				XCTAssertEqual(category, .opponents)
				return []
			}
		} operation: {
			let dataProvider: OpponentsDataProvider = .liveValue

			let result = try await dataProvider.fetchOpponents(.init(filter: nil, ordering: .byRecentlyUsed))

			XCTAssertEqual(result, [opponent1, opponent2, opponent3])
		}
	}

	func testFetchOpponents_ByRecentlyUsed_SortsByRecentlyUsed() async throws {
		let id0 = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
		let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
		let date = Date(timeIntervalSince1970: 1672519204)

		let opponent1: Opponent = .mock(id: id0, name: "first")
		let opponent2: Opponent = .mock(id: id1, name: "second")
		let opponent3: Opponent = .mock(id: id2, name: "third")

		try await withDependencies {
			$0.persistenceService.fetchOpponents = { _ in
				return [opponent1, opponent2, opponent3]
			}
			$0.recentlyUsedService.getRecentlyUsed = { category in
				XCTAssertEqual(category, .opponents)
				return [.init(id: id2, lastUsedAt: date), .init(id: id1, lastUsedAt: date)]
			}
		} operation: {
			let dataProvider: OpponentsDataProvider = .liveValue

			let result = try await dataProvider.fetchOpponents(.init(filter: nil, ordering: .byRecentlyUsed))

			XCTAssertEqual(result, [opponent3, opponent2, opponent1])
		}
	}

	func testFetchOpponents_ByName_SortsByName() async throws {
		let id0 = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
		let id1 = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
		let id2 = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
		let date = Date(timeIntervalSince1970: 1672519204)

		let opponent1: Opponent = .mock(id: id0, name: "first")
		let opponent2: Opponent = .mock(id: id1, name: "second")
		let opponent3: Opponent = .mock(id: id2, name: "third")

		try await withDependencies {
			$0.persistenceService.fetchOpponents = { _ in
				return [opponent1, opponent2, opponent3]
			}
			$0.recentlyUsedService.getRecentlyUsed = { category in
				XCTAssertEqual(category, .opponents)
				return [.init(id: id2, lastUsedAt: date), .init(id: id1, lastUsedAt: date)]
			}
		} operation: {
			let dataProvider: OpponentsDataProvider = .liveValue

			let result = try await dataProvider.fetchOpponents(.init(filter: nil, ordering: .byName))

			XCTAssertEqual(result, [opponent1, opponent2, opponent3])
		}
	}
}
