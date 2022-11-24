import Dependencies
import GRDB
import SharedModelsLibrary

extension Series: FetchableRecord, PersistableRecord {
	public func aroundInsert(_ db: Database, insert: () throws -> InsertionSuccess) throws {
		@Dependency(\.uuid) var uuid: UUIDGenerator
		@Dependency(\.date) var date: DateGenerator

		_ = try insert()

		for ordinal in (1...numberOfGames) {
			let game = Game(
				seriesId: id,
				id: uuid(),
				ordinal: ordinal,
				locked: .unlocked,
				manualScore: nil
			)
			try game.insert(db)
		}
	}
}
