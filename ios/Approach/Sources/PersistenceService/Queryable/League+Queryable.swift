import GRDB
import PersistenceServiceInterface
import SharedModelsFetchableLibrary
import SharedModelsLibrary
import SharedModelsPersistableLibrary

extension League.FetchRequest: ManyQueryable {
	@Sendable func fetchValues(_ db: Database) throws -> [League] {
		var query = League.all()

		switch filter {
		case let .id(id):
			query = query.filter(id: id)
		case let .properties(bowler, recurrence):
			query = bowler.leagues
			if let recurrence {
				query = query.filter(Column("recurrence") == recurrence.rawValue)
			}
		case .none:
			break
		}

		switch ordering {
		case .byName, .byRecentlyUsed:
			query = query.order(Column("name").collating(.localizedCaseInsensitiveCompare))
		}

		return try query.fetchAll(db)
	}
}
