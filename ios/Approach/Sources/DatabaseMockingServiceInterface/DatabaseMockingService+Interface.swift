import Dependencies

public struct DatabaseMockingService: Sendable {
	public var mockDatabase: @Sendable () async throws -> Void

	public init(mockDatabase: @escaping @Sendable () async throws -> Void) {
		self.mockDatabase = mockDatabase
	}
}

extension DatabaseMockingService: TestDependencyKey {
	public static var testValue = Self(
		mockDatabase: { unimplemented("\(Self.self).mockDatabase") }
	)
}

extension DependencyValues {
	public var databaseMocking: DatabaseMockingService {
		get { self[DatabaseMockingService.self] }
		set { self[DatabaseMockingService.self] = newValue }
	}
}
