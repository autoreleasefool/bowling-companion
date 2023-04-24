import AlleysRepositoryInterface
import DatabaseModelsLibrary
import DatabaseServiceInterface
import Dependencies
import GRDB
import ModelsLibrary
import RecentlyUsedServiceInterface
import RepositoryLibrary

extension AlleysRepository: DependencyKey {
	public static var liveValue: Self = {
		@Dependency(\.database) var database
		@Dependency(\.recentlyUsedService) var recentlyUsed

		return Self(
			list: { material, pinFall, mechanism, pinBase, ordering in
				let alleys = database.reader().observe {
					try Alley.Database
						.all()
						.orderByName()
						.filter(material, pinFall, mechanism, pinBase)
						.asRequest(of: Alley.Summary.self)
						.fetchAll($0)
				}

				switch ordering {
				case .byName:
					return alleys
				case .byRecentlyUsed:
					return sort(alleys, byIds: recentlyUsed.observeRecentlyUsedIds(.alleys))
				}
			},
			load: { id in
				database.reader().observeOne {
					try Alley.Summary.fetchOne($0, id: id)
				}
			},
			edit: { id in
				let lanesAlias = TableAlias(name: "lanes")
				return try await database.reader().read {
					try Alley.Database
						.filter(Alley.Database.Columns.id == id)
						.including(
							all: Alley.Database.lanes
								.order(Lane.Database.Columns.label.collating(.localizedCaseInsensitiveCompare))
								.aliased(lanesAlias)
						)
						.asRequest(of: Alley.EditWithLanes.self)
						.fetchOne($0)
				}
			},
			create: { alley in
				try await database.writer().write {
					try alley.insert($0)
				}
			},
			update: { alley in
				try await database.writer().write {
					try alley.update($0)
				}
			},
			delete: { id in
				_ = try await database.writer().write {
					try Alley.Database.deleteOne($0, id: id)
				}
			}
		)
	}()
}
