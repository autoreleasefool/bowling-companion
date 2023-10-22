import Foundation
import GRDB
import ModelsLibrary

extension Gear {
	public struct Database: Sendable, Identifiable, Codable, Equatable {
		public let id: Gear.ID
		public var name: String
		public var kind: Kind
		public var bowlerId: Bowler.ID?
		public var avatarId: Avatar.ID

		public init(
			id: Gear.ID,
			name: String,
			kind: Kind,
			bowlerId: Bowler.ID?,
			avatarId: Avatar.ID
		) {
			self.id = id
			self.name = name
			self.kind = kind
			self.bowlerId = bowlerId
			self.avatarId = avatarId
		}
	}
}

extension Gear.Database: TableRecord, FetchableRecord, PersistableRecord {
	public static let databaseTableName = "gear"
}

extension Gear.Kind: DatabaseValueConvertible {}

extension Gear.Database {
	public enum Columns {
		public static let id = Column(CodingKeys.id)
		public static let name = Column(CodingKeys.name)
		public static let kind = Column(CodingKeys.kind)
		public static let bowlerId = Column(CodingKeys.bowlerId)
		public static let avatarId = Column(CodingKeys.avatarId)
	}
}

extension DerivableRequest<Gear.Database> {
	public func includingOwnerName() -> Self {
		let ownerName = Bowler.Database.Columns.name.forKey("ownerName")
		return annotated(withOptional: Gear.Database.bowler.select(ownerName))
	}

	public func includingAvatar() -> Self {
		including(optional: Gear.Database.avatar)
	}

	public func includingSummaryProperties() -> Self {
		self
			.includingOwnerName()
			.includingAvatar()
	}

	public func orderByName() -> Self {
		let name = Gear.Database.Columns.name
		return order(name.collating(.localizedCaseInsensitiveCompare))
	}

	public func filter(byKind: Gear.Kind?) -> Self {
		guard let byKind else { return self }
		let kind = Gear.Database.Columns.kind
		return filter(kind == byKind)
	}

	public func owned(byBowler: Bowler.ID?) -> Self {
		guard let byBowler else { return self }
		let bowler = Gear.Database.Columns.bowlerId
		return filter(bowler == byBowler)
	}
}

extension Gear.Summary: FetchableRecord {}
