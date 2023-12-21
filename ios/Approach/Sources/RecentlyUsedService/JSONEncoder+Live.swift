import Dependencies
import Foundation
import RecentlyUsedServiceInterface

extension JSONEncoderService: DependencyKey {
	public static var liveValue: Self = {
		let encoder = JSONEncoder()
		return Self(
			encode: { try encoder.encode($0) }
		)
	}()
}
