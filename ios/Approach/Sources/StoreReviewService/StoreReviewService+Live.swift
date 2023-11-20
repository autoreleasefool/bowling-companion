import AppInfoServiceInterface
import Dependencies
import Foundation
import PreferenceServiceInterface
import StoreReviewServiceInterface

extension StoreReviewService: DependencyKey {
	public static var liveValue: Self = {
		return Self(
			shouldRequestReview: {
				@Dependency(\.appInfo) var appInfo
				let numberOfSessions = appInfo.numberOfSessions()

				@Dependency(\.preferences) var preferences
				let lastReviewRequest = Date(timeIntervalSince1970: preferences.double(forKey: .appLastReviewRequestDate) ?? 0)

				@Dependency(\.date) var date
				@Dependency(\.calendar) var calendar
				let daysSinceLastRequest = calendar.dateComponents([.day], from: lastReviewRequest, to: date.now).day ?? 0

				let installDate = appInfo.installDate()
				let daysSinceInstall = calendar.dateComponents([.day], from: installDate, to: date.now).day ?? 0

				return numberOfSessions >= 3 && daysSinceLastRequest >= 7 && daysSinceInstall >= 7
			},
			didRequestReview: {
				@Dependency(\.preferences) var preferences
				@Dependency(\.date) var date
				preferences.setKey(.appLastReviewRequestDate, toDouble: date.now.timeIntervalSince1970)
			}
		)
	}()
}
