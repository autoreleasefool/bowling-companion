import DatabaseModelsLibrary
import DatabaseServiceInterface
import Dependencies
import GamesRepositoryInterface
import GRDB
import MatchPlaysRepositoryInterface
import ModelsLibrary
import RepositoryLibrary

extension GamesRepository: DependencyKey {
	public static var liveValue: Self = {
		@Dependency(\.database) var database
		@Dependency(\.matchPlays) var matchPlays

		return Self(
			list: { series, _ in
				database.reader().observe {
					try Game.Database
						.all()
						.orderByIndex()
						.filter(bySeries: series)
						.annotated(withRequired: Game.Database.bowler.select(Bowler.Database.Columns.id.forKey("bowlerId")))
						.asRequest(of: Game.List.self)
						.fetchAll($0)
				}
			},
			edit: { id in
				try await database.reader().read {
					try Game.Database
						.filter(id: id)
						.including(required: Game.Database.bowler)
						.including(required: Game.Database.league)
						.including(
							optional: Game.Database.matchPlay
								.including(optional: MatchPlay.Database.opponent.forKey("opponent"))
						)
						// FIXME: should use game lanes, not series lanes
						.including(
							required: Game.Database.series
								.including(optional: Series.Database.alley)
								.including(
									all: Series.Database.lanes
										.orderByLabel()
								)
						)
						.including(
							all: Game.Database.gear
								.order(Gear.Database.Columns.kind)
								.order(Gear.Database.Columns.name)
								.forKey("gear")
						)
						.asRequest(of: Game.Edit.self)
						.fetchOne($0)
				}
			},
			update: { game in
				try await database.writer().write {
					try game.update($0)

					// FIXME: Rather than deleting all associations, should only add new/remove old
					try GameGear.Database
						.filter(GameGear.Database.Columns.gameId == game.id)
						.deleteAll($0)
					for gear in game.gear {
						let gameGear = GameGear.Database(gameId: game.id, gearId: gear.id)
						try gameGear.save($0)
					}
				}

				if let matchPlay = game.matchPlay {
					try await matchPlays.update(matchPlay)
				}
			},
			delete: { id in
				_ = try await database.writer().write {
					try Game.Database.deleteOne($0, id: id)
				}
			}
		)
	}()
}