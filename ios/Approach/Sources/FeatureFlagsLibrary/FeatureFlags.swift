// swiftlint:disable line_length
@_exported import FeatureFlagsPackageLibrary
@_exported import FeatureFlagsPackageServiceInterface

extension FeatureFlag {
	public static let developerOptions = Self(name: "developerOptions", introduced: "2022-11-10", stage: .development, isOverridable: false)
	public static let teams = Self(name: "teams", introduced: "2023-01-03", stage: .development)
	public static let opponentDetails = Self(name: "opponentDetails", introduced: "2023-08-18", stage: .development)
	public static let sharingGame = Self(name: "sharingGame", introduced: "2023-08-29", stage: .release)
	public static let sharingSeries = Self(name: "sharingSeries", introduced: "2023-08-29", stage: .release)
	public static let alleyAndGearAverages = Self(name: "alleyAndGearAverages", introduced: "2023-09-12", stage: .development)
	public static let proSubscription = Self(name: "proSubscription", introduced: "2023-08-08", stage: .development)
	public static let purchases = Self(name: "purchase", introduced: "2023-09-15", stage: .disabled)
	public static let dataImport = Self(name: "dataImport", introduced: "2023-09-17", stage: .development)
	public static let preBowlForm = Self(name: "preBowlForm", introduced: "2024-03-23", stage: .release)
	public static let manualSeries = Self(name: "manualSeries", introduced: "2024-03-28", stage: .release)
	public static let sharingStatistic = Self(name: "sharingStatistic", introduced: "2024-04-27", stage: .release)
	public static let photoAvatars = Self(name: "photoAvatars", introduced: "2024-07-05", stage: .development)
	public static let bowlerDetails = Self(name: "bowlerDetails", introduced: "2024-07-05", stage: .development)
	public static let badges = Self(name: "badges", introduced: "2024-08-11", stage: .development)

	public static let allFlags: [Self] = [
		.alleyAndGearAverages,
		.badges,
		.bowlerDetails,
		.dataImport,
		.developerOptions,
		.manualSeries,
		.opponentDetails,
		.photoAvatars,
		.preBowlForm,
		.proSubscription,
		.purchases,
		.sharingGame,
		.sharingSeries,
		.sharingStatistic,
		.teams,
	]

	public static func find(byId: FeatureFlag.ID) -> FeatureFlag? {
		allFlags.first { $0.id == byId }
	}
}

// swiftlint:enable line_length
