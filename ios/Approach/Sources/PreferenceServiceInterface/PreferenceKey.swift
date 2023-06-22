public enum PreferenceKey: String {

	// MARK: - App

	case appDidCompleteOnboarding                   // default: false

	// MARK: - Statistics

	case statisticsOverviewHintHidden               // default: false
	case statisticsDetailsHintHidden                // default: false
	case statisticsCountH2AsH                       // default: true
	case statisticsHideZeroStatistics               // default: true
}
