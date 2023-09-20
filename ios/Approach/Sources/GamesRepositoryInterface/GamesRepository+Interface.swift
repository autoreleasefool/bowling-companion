import Dependencies
import ModelsLibrary

extension Game {
	public enum Ordering: Hashable, CaseIterable {
		case byIndex
	}
}

public struct GamesRepository: Sendable {
	public var list: @Sendable (Series.ID, Game.Ordering) -> AsyncThrowingStream<[Game.List], Error>
	public var summariesList: @Sendable (Series.ID, Game.Ordering) -> AsyncThrowingStream<[Game.Summary], Error>
	public var matchesAgainstOpponent: @Sendable (Bowler.ID) -> AsyncThrowingStream<[Game.ListMatch], Error>
	public var shareGames: @Sendable ([Game.ID]) async throws -> [Game.Shareable]
	public var shareSeries: @Sendable (Series.ID) async throws -> [Game.Shareable]
	public var observe: @Sendable (Game.ID) -> AsyncThrowingStream<Game.Edit?, Error>
	public var findIndex: @Sendable (Game.ID) async throws -> Game.Indexed?
	public var update: @Sendable (Game.Edit) async throws -> Void
	public var delete: @Sendable (Game.ID) async throws -> Void

	public init(
		list: @escaping @Sendable (Series.ID, Game.Ordering) -> AsyncThrowingStream<[Game.List], Error>,
		summariesList: @escaping @Sendable (Series.ID, Game.Ordering) -> AsyncThrowingStream<[Game.Summary], Error>,
		matchesAgainstOpponent: @escaping @Sendable (Bowler.ID) -> AsyncThrowingStream<[Game.ListMatch], Error>,
		shareGames: @escaping @Sendable ([Game.ID]) async throws -> [Game.Shareable],
		shareSeries: @escaping @Sendable (Series.ID) async throws -> [Game.Shareable],
		observe: @escaping @Sendable (Game.ID) -> AsyncThrowingStream<Game.Edit?, Error>,
		findIndex: @escaping @Sendable (Game.ID) async throws -> Game.Indexed?,
		update: @escaping @Sendable (Game.Edit) async throws -> Void,
		delete: @escaping @Sendable (Game.ID) async throws -> Void
	) {
		self.list = list
		self.summariesList = summariesList
		self.matchesAgainstOpponent = matchesAgainstOpponent
		self.shareGames = shareGames
		self.shareSeries = shareSeries
		self.observe = observe
		self.findIndex = findIndex
		self.update = update
		self.delete = delete
	}

	public func seriesGames(forId: Series.ID, ordering: Game.Ordering) -> AsyncThrowingStream<[Game.List], Error> {
		self.list(forId, ordering)
	}

	public func seriesGamesSummaries(
		forId: Series.ID,
		ordering: Game.Ordering
	) -> AsyncThrowingStream<[Game.Summary], Error> {
		self.summariesList(forId, ordering)
	}

	public func matches(against opponent: Bowler.ID) -> AsyncThrowingStream<[Game.ListMatch], Error> {
		self.matchesAgainstOpponent(opponent)
	}
}

extension GamesRepository: TestDependencyKey {
	public static var testValue = Self(
		list: { _, _ in unimplemented("\(Self.self).list") },
		summariesList: { _, _ in unimplemented("\(Self.self).summariesList") },
		matchesAgainstOpponent: { _ in unimplemented("\(Self.self).matchesAgainstOpponent") },
		shareGames: { _ in unimplemented("\(Self.self).shareGames") },
		shareSeries: { _ in unimplemented("\(Self.self).shareSeries") },
		observe: { _ in unimplemented("\(Self.self).observeChanges") },
		findIndex: { _ in unimplemented("\(Self.self).findIndex") },
		update: { _ in unimplemented("\(Self.self).update") },
		delete: { _ in unimplemented("\(Self.self).delete") }
	)
}

extension DependencyValues {
	public var games: GamesRepository {
		get { self[GamesRepository.self] }
		set { self[GamesRepository.self] = newValue }
	}
}
