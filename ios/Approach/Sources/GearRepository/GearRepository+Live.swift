import DatabaseModelsLibrary
import DatabaseServiceInterface
import Dependencies
import GearRepositoryInterface
import GRDB
import ModelsLibrary
import RecentlyUsedServiceInterface
import RepositoryLibrary

public typealias GearStream = AsyncThrowingStream<[Gear.Summary], Error>

extension GearRepository: DependencyKey {
	public static var liveValue: Self = {
		@Dependency(\.database) var database
		@Dependency(\.recentlyUsed) var recentlyUsed

		@Sendable func sortGear(
			_ gear: GearStream,
			_ ordering: Gear.Ordering
		) -> GearStream {
			switch ordering {
			case .byName:
				return gear
			case .byRecentlyUsed:
				return sort(gear, byIds: recentlyUsed.observeRecentlyUsedIds(.gear))
			}
		}

		return Self(
			list: { owner, kind, ordering in
				let gear = database.reader().observe {
					try Gear.Database
						.all()
						.orderByName()
						.filter(byKind: kind)
						.owned(byBowler: owner)
						.includingSummaryProperties()
						.asRequest(of: Gear.Summary.self)
						.fetchAll($0)
				}
				return sortGear(gear, ordering)
			},
			preferred: { bowler in
				try await database.reader().read {
					try Gear.Database
						.having(
							Gear.Database.bowlerPreferredGear
								.filter(BowlerPreferredGear.Database.Columns.bowlerId == bowler).isEmpty == false
						)
						.orderByName()
						.includingSummaryProperties()
						.asRequest(of: Gear.Summary.self)
						.fetchAll($0)
				}
			},
			mostRecentlyUsed: { kind, limit in
				let gear = database.reader().observe {
					try Gear.Database
						.all()
						.filter(byKind: kind)
						.orderByName()
						.includingSummaryProperties()
						.asRequest(of: Gear.Summary.self)
						.fetchAll($0)
				}
				return prefix(sortGear(gear, .byRecentlyUsed), ofSize: limit)
			},
			edit: { id in
				try await database.reader().read {
					try Gear.Database
						.filter(Gear.Database.Columns.id == id)
						.including(optional: Gear.Database.bowler.forKey("owner"))
						.includingAvatar()
						.asRequest(of: Gear.Edit.self)
						.fetchOneGuaranteed($0)
				}
			},
			create: { gear in
				try await database.writer().write {
					try gear.avatar.databaseModel.insert($0)
					try gear.insert($0)
				}
			},
			update: { gear in
				try await database.writer().write {
					try gear.update($0)
					try gear.avatar.databaseModel.update($0)
				}
			},
			delete: { id in
				_ = try await database.writer().write {
					try Gear.Database.deleteOne($0, id: id)
				}
			},
			updatePreferredGear: { bowler, gear in
				try await database.writer().write {
					// FIXME: Rather than deleting all associations, should only add new/remove old
					try BowlerPreferredGear.Database
						.filter(BowlerPreferredGear.Database.Columns.bowlerId == bowler)
						.deleteAll($0)
					for gear in gear {
						let bowlerPreferredGear = BowlerPreferredGear.Database(bowlerId: bowler, gearId: gear)
						try bowlerPreferredGear.insert($0)
					}
				}
			}
		)
	}()
}
