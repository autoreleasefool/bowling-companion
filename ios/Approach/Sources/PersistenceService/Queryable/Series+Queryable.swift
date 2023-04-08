import GRDB
import PersistenceServiceInterface
import SharedModelsFetchableLibrary
import SharedModelsLibrary
import SharedModelsPersistableLibrary

extension Series.FetchRequest: ManyQueryable {
	@Sendable func fetchValues(_ db: Database) throws -> [Series] {
		var query = Series.all()

		switch filter {
		case let .id(id):
			query = query.filter(id: id)
		case let .league(league):
			query = league.series
		case .none:
			break
		}

		switch ordering {
		case .byDate:
			query = query.order(Column("date").desc)
		}

		return try query.fetchAll(db)
	}
}
