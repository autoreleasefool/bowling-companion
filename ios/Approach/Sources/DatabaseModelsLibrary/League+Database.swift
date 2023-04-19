import ExtensionsLibrary
import Foundation
import GRDB
import ModelsLibrary

extension League {
	public struct Database: Sendable, Identifiable, Codable, TableRecord {
		public static let databaseTableName = "league"

		public let bowlerId: Bowler.ID
		public let id: League.ID
		public var name: String
		public var recurrence: Recurrence
		public var numberOfGames: Int?
		public var additionalPinfall: Int?
		public var additionalGames: Int?
		public var excludeFromStatistics: ExcludeFromStatistics
		public var alleyId: Alley.ID?

		public init(
			bowlerId: Bowler.ID,
			id: League.ID,
			name: String,
			recurrence: Recurrence,
			numberOfGames: Int?,
			additionalPinfall: Int?,
			additionalGames: Int?,
			excludeFromStatistics: ExcludeFromStatistics,
			alleyId: Alley.ID?
		) {
			self.bowlerId = bowlerId
			self.id = id
			self.name = name
			self.recurrence = recurrence
			self.numberOfGames = numberOfGames
			self.additionalPinfall = additionalPinfall
			self.additionalGames = additionalGames
			self.excludeFromStatistics = excludeFromStatistics
			self.alleyId = alleyId
		}
	}
}

extension League.Recurrence: DatabaseValueConvertible {}
extension League.ExcludeFromStatistics: DatabaseValueConvertible {}

extension League.Database: FetchableRecord, PersistableRecord {
	public func willSave(_ db: Database) throws {
		guard id != .placeholder else { throw PlaceholderIDValidationError() }
	}

	public static let alley = belongsTo(Alley.Database.self)
	public var alley: QueryInterfaceRequest<Alley.Database> { request(for: Self.alley) }
}

extension League.Database {
	public enum Columns {
		public static let bowlerId = Column(CodingKeys.bowlerId)
		public static let id = Column(CodingKeys.id)
		public static let name = Column(CodingKeys.name)
		public static let recurrence = Column(CodingKeys.recurrence)
		public static let numberOfGames = Column(CodingKeys.numberOfGames)
		public static let additionalPinfall = Column(CodingKeys.additionalPinfall)
		public static let additionalGames = Column(CodingKeys.additionalGames)
		public static let excludeFromStatistics = Column(CodingKeys.excludeFromStatistics)
		public static let alleyId = Column(CodingKeys.alleyId)
	}
}

extension League.Summary: TableRecord, FetchableRecord {
	public static let databaseTableName = League.Database.databaseTableName
}
