import Dependencies

public struct LaunchService: Sendable {
	public var didInit: @Sendable () -> Void
	public var didLaunch: @Sendable () async -> Void

	public init(
		didInit: @escaping @Sendable () -> Void,
		didLaunch: @escaping @Sendable () async -> Void
	) {
		self.didInit = didInit
		self.didLaunch = didLaunch
	}
}

extension LaunchService: TestDependencyKey {
	public static var testValue = Self(
		didInit: { unimplemented("\(Self.self).didInit") },
		didLaunch: { unimplemented("\(Self.self).didLaunch") }
	)
}

extension DependencyValues {
	public var launch: LaunchService {
		get { self[LaunchService.self] }
		set { self[LaunchService.self] = newValue }
	}
}
