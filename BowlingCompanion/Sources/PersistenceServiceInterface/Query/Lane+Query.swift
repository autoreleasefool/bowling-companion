import SharedModelsLibrary

extension Lane {
	public struct Query: Equatable {
		public let filter: [Filter]
		public let ordering: Ordering

		public init(filter: [Filter], ordering: Ordering) {
			self.filter = filter
			self.ordering = ordering
		}
	}
}

extension Lane.Query {
	public enum Filter: Equatable {
		case id(Lane.ID)
		case alley(Alley.ID)
	}
}

extension Lane.Query {
	public enum Ordering {
		case byLabel
	}
}
