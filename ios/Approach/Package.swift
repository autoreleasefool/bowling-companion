// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "Approach",
	defaultLocalization: "en",
	platforms: [
		.iOS("17.0"),
	],
	products: [
		// MARK: - Features
		.library(name: "AccessoriesOverviewFeature", targets: ["AccessoriesOverviewFeature"]),
		.library(name: "AddressLookupFeature", targets: ["AddressLookupFeature"]),
		.library(name: "AlleyEditorFeature", targets: ["AlleyEditorFeature"]),
		.library(name: "AlleysListFeature", targets: ["AlleysListFeature"]),
		.library(name: "AnnouncementsFeature", targets: ["AnnouncementsFeature"]),
		.library(name: "AppFeature", targets: ["AppFeature"]),
		.library(name: "ArchiveListFeature", targets: ["ArchiveListFeature"]),
		.library(name: "AvatarEditorFeature", targets: ["AvatarEditorFeature"]),
		.library(name: "BowlerDetailsFeature", targets: ["BowlerDetailsFeature"]),
		.library(name: "BowlerEditorFeature", targets: ["BowlerEditorFeature"]),
		.library(name: "BowlersListFeature", targets: ["BowlersListFeature"]),
		.library(name: "ErrorsFeature", targets: ["ErrorsFeature"]),
		.library(name: "FeatureFlagsListFeature", targets: ["FeatureFlagsListFeature"]),
		.library(name: "FormFeature", targets: ["FormFeature"]),
		.library(name: "GamesEditorFeature", targets: ["GamesEditorFeature"]),
		.library(name: "GamesListFeature", targets: ["GamesListFeature"]),
		.library(name: "GearEditorFeature", targets: ["GearEditorFeature"]),
		.library(name: "GearListFeature", targets: ["GearListFeature"]),
		.library(name: "ImportExportFeature", targets: ["ImportExportFeature"]),
		.library(name: "LaneEditorFeature", targets: ["LaneEditorFeature"]),
		.library(name: "LeagueEditorFeature", targets: ["LeagueEditorFeature"]),
		.library(name: "LeaguesListFeature", targets: ["LeaguesListFeature"]),
		.library(name: "OnboardingFeature", targets: ["OnboardingFeature"]),
		.library(name: "OpponentDetailsFeature", targets: ["OpponentDetailsFeature"]),
		.library(name: "OpponentsListFeature", targets: ["OpponentsListFeature"]),
		.library(name: "PaywallFeature", targets: ["PaywallFeature"]),
		.library(name: "SeriesEditorFeature", targets: ["SeriesEditorFeature"]),
		.library(name: "SeriesListFeature", targets: ["SeriesListFeature"]),
		.library(name: "SettingsFeature", targets: ["SettingsFeature"]),
		.library(name: "SharingFeature", targets: ["SharingFeature"]),
		.library(name: "StatisticsDetailsFeature", targets: ["StatisticsDetailsFeature"]),
		.library(name: "StatisticsOverviewFeature", targets: ["StatisticsOverviewFeature"]),
		.library(name: "StatisticsWidgetEditorFeature", targets: ["StatisticsWidgetEditorFeature"]),
		.library(name: "StatisticsWidgetsLayoutFeature", targets: ["StatisticsWidgetsLayoutFeature"]),

		// MARK: - Repositories
		.library(name: "AlleysRepository", targets: ["AlleysRepository"]),
		.library(name: "AlleysRepositoryInterface", targets: ["AlleysRepositoryInterface"]),
		.library(name: "BowlersRepository", targets: ["BowlersRepository"]),
		.library(name: "BowlersRepositoryInterface", targets: ["BowlersRepositoryInterface"]),
		.library(name: "FramesRepository", targets: ["FramesRepository"]),
		.library(name: "FramesRepositoryInterface", targets: ["FramesRepositoryInterface"]),
		.library(name: "GamesRepository", targets: ["GamesRepository"]),
		.library(name: "GamesRepositoryInterface", targets: ["GamesRepositoryInterface"]),
		.library(name: "GearRepository", targets: ["GearRepository"]),
		.library(name: "GearRepositoryInterface", targets: ["GearRepositoryInterface"]),
		.library(name: "LanesRepository", targets: ["LanesRepository"]),
		.library(name: "LanesRepositoryInterface", targets: ["LanesRepositoryInterface"]),
		.library(name: "LeaguesRepository", targets: ["LeaguesRepository"]),
		.library(name: "LeaguesRepositoryInterface", targets: ["LeaguesRepositoryInterface"]),
		.library(name: "LocationsRepository", targets: ["LocationsRepository"]),
		.library(name: "LocationsRepositoryInterface", targets: ["LocationsRepositoryInterface"]),
		.library(name: "MatchPlaysRepository", targets: ["MatchPlaysRepository"]),
		.library(name: "MatchPlaysRepositoryInterface", targets: ["MatchPlaysRepositoryInterface"]),
		.library(name: "QuickLaunchRepository", targets: ["QuickLaunchRepository"]),
		.library(name: "QuickLaunchRepositoryInterface", targets: ["QuickLaunchRepositoryInterface"]),
		.library(name: "ScoresRepository", targets: ["ScoresRepository"]),
		.library(name: "ScoresRepositoryInterface", targets: ["ScoresRepositoryInterface"]),
		.library(name: "SeriesRepository", targets: ["SeriesRepository"]),
		.library(name: "SeriesRepositoryInterface", targets: ["SeriesRepositoryInterface"]),
		.library(name: "StatisticsRepository", targets: ["StatisticsRepository"]),
		.library(name: "StatisticsRepositoryInterface", targets: ["StatisticsRepositoryInterface"]),
		.library(name: "StatisticsWidgetsRepository", targets: ["StatisticsWidgetsRepository"]),
		.library(name: "StatisticsWidgetsRepositoryInterface", targets: ["StatisticsWidgetsRepositoryInterface"]),

		// MARK: - Data Providers

		// MARK: - Services
		.library(name: "AddressLookupService", targets: ["AddressLookupService"]),
		.library(name: "AddressLookupServiceInterface", targets: ["AddressLookupServiceInterface"]),
		.library(name: "AnalyticsService", targets: ["AnalyticsService"]),
		.library(name: "AnalyticsServiceInterface", targets: ["AnalyticsServiceInterface"]),
		.library(name: "AppIconService", targets: ["AppIconService"]),
		.library(name: "AppIconServiceInterface", targets: ["AppIconServiceInterface"]),
		.library(name: "AvatarService", targets: ["AvatarService"]),
		.library(name: "AvatarServiceInterface", targets: ["AvatarServiceInterface"]),
		.library(name: "DatabaseMockingService", targets: ["DatabaseMockingService"]),
		.library(name: "DatabaseMockingServiceInterface", targets: ["DatabaseMockingServiceInterface"]),
		.library(name: "DatabaseService", targets: ["DatabaseService"]),
		.library(name: "DatabaseServiceInterface", targets: ["DatabaseServiceInterface"]),
		.library(name: "EmailService", targets: ["EmailService"]),
		.library(name: "EmailServiceInterface", targets: ["EmailServiceInterface"]),
		.library(name: "ImportExportService", targets: ["ImportExportService"]),
		.library(name: "ImportExportServiceInterface", targets: ["ImportExportServiceInterface"]),
		.library(name: "LaunchService", targets: ["LaunchService"]),
		.library(name: "LaunchServiceInterface", targets: ["LaunchServiceInterface"]),
		.library(name: "LoggingService", targets: ["LoggingService"]),
		.library(name: "LoggingServiceInterface", targets: ["LoggingServiceInterface"]),
		.library(name: "NotificationsService", targets: ["NotificationsService"]),
		.library(name: "NotificationsServiceInterface", targets: ["NotificationsServiceInterface"]),
		.library(name: "PreferenceService", targets: ["PreferenceService"]),
		.library(name: "PreferenceServiceInterface", targets: ["PreferenceServiceInterface"]),
		.library(name: "ProductsService", targets: ["ProductsService"]),
		.library(name: "ProductsServiceInterface", targets: ["ProductsServiceInterface"]),
		.library(name: "RecentlyUsedService", targets: ["RecentlyUsedService"]),
		.library(name: "RecentlyUsedServiceInterface", targets: ["RecentlyUsedServiceInterface"]),
		.library(name: "TipsService", targets: ["TipsService"]),
		.library(name: "TipsServiceInterface", targets: ["TipsServiceInterface"]),
		.library(name: "ZIPService", targets: ["ZIPService"]),
		.library(name: "ZIPServiceInterface", targets: ["ZIPServiceInterface"]),

		// MARK: - Libraries
		.library(name: "AssetsLibrary", targets: ["AssetsLibrary"]),
		.library(name: "ComposableExtensionsLibrary", targets: ["ComposableExtensionsLibrary"]),
		.library(name: "ConstantsLibrary", targets: ["ConstantsLibrary"]),
		.library(name: "DatabaseMigrationsLibrary", targets: ["DatabaseMigrationsLibrary"]),
		.library(name: "DatabaseModelsLibrary", targets: ["DatabaseModelsLibrary"]),
		.library(name: "DateTimeLibrary", targets: ["DateTimeLibrary"]),
		.library(name: "FeatureActionLibrary", targets: ["FeatureActionLibrary"]),
		.library(name: "FeatureFlagsLibrary", targets: ["FeatureFlagsLibrary"]),
		.library(name: "ListContentLibrary", targets: ["ListContentLibrary"]),
		.library(name: "ModelsLibrary", targets: ["ModelsLibrary"]),
		.library(name: "ModelsViewsLibrary", targets: ["ModelsViewsLibrary"]),
		.library(name: "PickableModelsLibrary", targets: ["PickableModelsLibrary"]),
		.library(name: "ProductsLibrary", targets: ["ProductsLibrary"]),
		.library(name: "ReorderingLibrary", targets: ["ReorderingLibrary"]),
		.library(name: "RepositoryLibrary", targets: ["RepositoryLibrary"]),
		.library(name: "ResourceListLibrary", targets: ["ResourceListLibrary"]),
		.library(name: "ResourcePickerLibrary", targets: ["ResourcePickerLibrary"]),
		.library(name: "ScoreKeeperLibrary", targets: ["ScoreKeeperLibrary"]),
		.library(name: "ScoreKeeperModelsLibrary", targets: ["ScoreKeeperModelsLibrary"]),
		.library(name: "ScoreSheetLibrary", targets: ["ScoreSheetLibrary"]),
		.library(name: "SortOrderLibrary", targets: ["SortOrderLibrary"]),
		.library(name: "SortingLibrary", targets: ["SortingLibrary"]),
		.library(name: "StatisticsChartsLibrary", targets: ["StatisticsChartsLibrary"]),
		.library(name: "StatisticsChartsMocksLibrary", targets: ["StatisticsChartsMocksLibrary"]),
		.library(name: "StatisticsLibrary", targets: ["StatisticsLibrary"]),
		.library(name: "StatisticsModelsLibrary", targets: ["StatisticsModelsLibrary"]),
		.library(name: "StatisticsWidgetsLibrary", targets: ["StatisticsWidgetsLibrary"]),
		.library(name: "StringsLibrary", targets: ["StringsLibrary"]),
		.library(name: "TestDatabaseUtilitiesLibrary", targets: ["TestDatabaseUtilitiesLibrary"]),
		.library(name: "TipsLibrary", targets: ["TipsLibrary"]),
		.library(name: "ToastLibrary", targets: ["ToastLibrary"]),
		.library(name: "ViewsLibrary", targets: ["ViewsLibrary"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
		.package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-collections.git", from: "1.1.3"),
		.package(url: "https://github.com/autoreleasefool/swift-utilities.git", branch: "grdb-7-beta"),
		.package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.8.5"),
		.package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.36.0"),
		.package(url: "https://github.com/groue/GRDB.swift.git", revision: "ed5f8c11ab53a4df0f882f1045c65aab59193611"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.15.0"),
		.package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.2.0"),
		.package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.4.1"),
		.package(url: "https://github.com/pointfreeco/swift-identified-collections.git", from: "1.1.0"),
		.package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.4"),
		.package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git", from: "1.4.0"),
		.package(url: "https://github.com/quanshousio/ToastUI.git", from: "4.0.0"),
		.package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "5.3.0"),
		.package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.19"),
	],
	targets: [
		// MARK: - Features
		.target(
			name: "AccessoriesOverviewFeature",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms"),
				"AlleysListFeature",
				"GearListFeature",
			]
		),
		.testTarget(
			name: "AccessoriesOverviewFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AccessoriesOverviewFeature",
			]
		),
		.target(
			name: "AddressLookupFeature",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"AddressLookupServiceInterface",
				"AnalyticsServiceInterface",
				"FeatureActionLibrary",
				"LocationsRepositoryInterface",
				"LoggingServiceInterface",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "AddressLookupFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AddressLookupFeature",
			]
		),
		.target(
			name: "AlleyEditorFeature",
			dependencies: [
				"AddressLookupFeature",
				"AlleysRepositoryInterface",
				"FormFeature",
				"LaneEditorFeature",
				"ModelsViewsLibrary",
			]
		),
		.testTarget(
			name: "AlleyEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AlleyEditorFeature",
			]
		),
		.target(
			name: "AlleysListFeature",
			dependencies: [
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"AlleyEditorFeature",
				"FeatureFlagsLibrary",
				"ResourceListLibrary",
			]
		),
		.testTarget(
			name: "AlleysListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AlleysListFeature",
			]
		),
		.target(
			name: "AnnouncementsFeature",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				.product(name: "UserDefaultsPackageServiceInterface", package: "swift-utilities"),
				"AnalyticsServiceInterface",
				"FeatureActionLibrary",
				"LoggingServiceInterface",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "AnnouncementsFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AnnouncementsFeature",
			]
		),
		.target(
			name: "AppFeature",
			dependencies: [
				.product(name: "AppInfoPackageService", package: "swift-utilities"),
				.product(name: "BundlePackageService", package: "swift-utilities"),
				.product(name: "FeatureFlagsPackageService", package: "swift-utilities"),
				.product(name: "FileManagerPackageService", package: "swift-utilities"),
				.product(name: "GRDBDatabasePackageService", package: "swift-utilities"),
				.product(name: "PasteboardPackageService", package: "swift-utilities"),
				.product(name: "SentryErrorReportingPackageService", package: "swift-utilities"),
				.product(name: "StoreReviewPackageService", package: "swift-utilities"),
				.product(name: "TelemetryDeckAnalyticsPackageService", package: "swift-utilities"),
				.product(name: "UserDefaultsPackageService", package: "swift-utilities"),
				"AccessoriesOverviewFeature",
				"BowlersListFeature",
				"LaunchServiceInterface",
				"OnboardingFeature",
				"SettingsFeature",
				"StatisticsOverviewFeature",
			]
		),
		.testTarget(
			name: "AppFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AppFeature",
			]
		),
		.target(
			name: "ArchiveListFeature",
			dependencies: [
				"BowlersRepositoryInterface",
				"DateTimeLibrary",
				"ErrorsFeature",
				"GamesRepositoryInterface",
				"LeaguesRepositoryInterface",
				"ModelsViewsLibrary",
				"SeriesRepositoryInterface",
			]
		),
		.testTarget(
			name: "ArchiveListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ArchiveListFeature",
			]
		),
		.target(
			name: "AvatarEditorFeature",
			dependencies: [
				.product(name: "EquatablePackageLibrary", package: "swift-utilities"),
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"AnalyticsServiceInterface",
				"AvatarServiceInterface",
				"ComposableExtensionsLibrary",
				"FeatureActionLibrary",
				"FeatureFlagsLibrary",
				"LoggingServiceInterface",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "AvatarEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AvatarEditorFeature",
			]
		),
		.target(
			name: "BowlerDetailsFeature",
			dependencies: [
				"BowlerEditorFeature",
				"LeaguesListFeature",
			]
		),
		.testTarget(
			name: "BowlerDetailsFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"BowlerDetailsFeature",
			]
		),
		.target(
			name: "BowlerEditorFeature",
			dependencies: [
				"BowlersRepositoryInterface",
				"FormFeature",
			]
		),
		.testTarget(
			name: "BowlerEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"BowlerEditorFeature",
			]
		),
		.target(
			name: "BowlersListFeature",
			dependencies: [
				"AnnouncementsFeature",
				"BowlerDetailsFeature",
				"QuickLaunchRepositoryInterface",
			]
		),
		.testTarget(
			name: "BowlersListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"BowlersListFeature",
			]
		),
		.target(
			name: "ErrorsFeature",
			dependencies: [
				.product(name: "AppInfoPackageServiceInterface", package: "swift-utilities"),
				.product(name: "EquatablePackageLibrary", package: "swift-utilities"),
				.product(name: "FileManagerPackageServiceInterface", package: "swift-utilities"),
				.product(name: "PasteboardPackageServiceInterface", package: "swift-utilities"),
				"AnalyticsServiceInterface",
				"ConstantsLibrary",
				"EmailServiceInterface",
				"FeatureActionLibrary",
				"LoggingServiceInterface",
				"ToastLibrary",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "ErrorsFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ErrorsFeature",
			]
		),
		.target(
			name: "FeatureFlagsListFeature",
			dependencies: [
				"AnalyticsServiceInterface",
				"FeatureActionLibrary",
				"FeatureFlagsLibrary",
				"LoggingServiceInterface",
				"StringsLibrary",
			]
		),
		.testTarget(
			name: "FeatureFlagsListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"FeatureFlagsListFeature",
			]
		),
		.target(
			name: "FormFeature",
			dependencies: [
				"ErrorsFeature",
			]
		),
		.testTarget(
			name: "FormFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"FormFeature",
			]
		),
		.target(
			name: "GamesEditorFeature",
			dependencies: [
				.product(name: "StoreReviewPackageServiceInterface", package: "swift-utilities"),
				"AvatarServiceInterface",
				"FeatureFlagsLibrary",
				"FramesRepositoryInterface",
				"GearRepositoryInterface",
				"LanesRepositoryInterface",
				"StatisticsDetailsFeature",
			]
		),
		.testTarget(
			name: "GamesEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"GamesEditorFeature",
			]
		),
		.target(
			name: "GamesListFeature",
			dependencies: [
				"GamesEditorFeature",
				"ResourceListLibrary",
				"SeriesEditorFeature",
			]
		),
		.testTarget(
			name: "GamesListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"GamesListFeature",
			]
		),
		.target(
			name: "GearEditorFeature",
			dependencies: [
				"AvatarEditorFeature",
				"BowlersRepositoryInterface",
				"FormFeature",
				"GearRepositoryInterface",
				"PickableModelsLibrary",
			]
		),
		.testTarget(
			name: "GearEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"GearEditorFeature",
			]
		),
		.target(
			name: "GearListFeature",
			dependencies: [
				"GearEditorFeature",
				"RecentlyUsedServiceInterface",
				"ResourceListLibrary",
				"SortOrderLibrary",
			]
		),
		.testTarget(
			name: "GearListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"GearListFeature",
			]
		),
		.target(
			name: "ImportExportFeature",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"DateTimeLibrary",
				"ErrorsFeature",
				"ImportExportServiceInterface",
				"PreferenceServiceInterface",
			]
		),
		.testTarget(
			name: "ImportExportFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ImportExportFeature",
			]
		),
		.target(
			name: "LaneEditorFeature",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"AnalyticsServiceInterface",
				"FeatureActionLibrary",
				"LoggingServiceInterface",
				"ModelsLibrary",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "LaneEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"LaneEditorFeature",
			]
		),
		.target(
			name: "LeagueEditorFeature",
			dependencies: [
				"AlleysRepositoryInterface",
				"FormFeature",
				"LeaguesRepositoryInterface",
				"ModelsViewsLibrary",
				"PickableModelsLibrary",
			]
		),
		.testTarget(
			name: "LeagueEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"LeagueEditorFeature",
			]
		),
		.target(
			name: "LeaguesListFeature",
			dependencies: [
				"SeriesListFeature",
				"StatisticsWidgetsLayoutFeature",
			]
		),
		.testTarget(
			name: "LeaguesListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"LeaguesListFeature",
			]
		),
		.target(
			name: "OnboardingFeature",
			dependencies: [
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"AnalyticsServiceInterface",
				"BowlersRepositoryInterface",
				"FeatureActionLibrary",
				"LoggingServiceInterface",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "OnboardingFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"OnboardingFeature",
			]
		),
		.target(
			name: "OpponentDetailsFeature",
			dependencies: [
				"BowlerEditorFeature",
				"GamesRepositoryInterface",
				"ResourceListLibrary",
			]
		),
		.testTarget(
			name: "OpponentDetailsFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"OpponentDetailsFeature",
			]
		),
		.target(
			name: "OpponentsListFeature",
			dependencies: [
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"FeatureFlagsLibrary",
				"ModelsViewsLibrary",
				"OpponentDetailsFeature",
				"RecentlyUsedServiceInterface",
				"SortOrderLibrary",
			]
		),
		.testTarget(
			name: "OpponentsListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"OpponentsListFeature",
			]
		),
		.target(
			name: "PaywallFeature",
			dependencies: [
				"ErrorsFeature",
				"ProductsServiceInterface",
			]
		),
		.testTarget(
			name: "PaywallFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"PaywallFeature",
			]
		),
		.target(
			name: "SeriesEditorFeature",
			dependencies: [
				"AlleysRepositoryInterface",
				"DateTimeLibrary",
				"FormFeature",
				"ModelsViewsLibrary",
				"PickableModelsLibrary",
				"SeriesRepositoryInterface",
			]
		),
		.testTarget(
			name: "SeriesEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SeriesEditorFeature",
			]
		),
		.target(
			name: "SeriesListFeature",
			dependencies: [
				"GamesListFeature",
				"LeagueEditorFeature",
				"SortOrderLibrary",
			]
		),
		.testTarget(
			name: "SeriesListFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SeriesListFeature",
			]
		),
		.target(
			name: "SettingsFeature",
			dependencies: [
				.product(name: "BundlePackageServiceInterface", package: "swift-utilities"),
				"AppIconServiceInterface",
				"ArchiveListFeature",
				"DatabaseMockingServiceInterface",
				"FeatureFlagsListFeature",
				"ImportExportFeature",
				"OpponentsListFeature",
				"ProductsServiceInterface",
			]
		),
		.testTarget(
			name: "SettingsFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SettingsFeature",
			]
		),
		.target(
			name: "SharingFeature",
			dependencies: [
				"GamesRepositoryInterface",
				"ScoreSheetLibrary",
				"ScoresRepositoryInterface",
				"SeriesRepositoryInterface",
				"StatisticsWidgetEditorFeature",
			]
		),
		.testTarget(
			name: "SharingFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SharingFeature",
			]
		),
		.target(
			name: "StatisticsDetailsFeature",
			dependencies: [
				"NotificationsServiceInterface",
				"PreferenceServiceInterface",
				"RecentlyUsedServiceInterface",
				"SharingFeature",
				"TipsServiceInterface",
			]
		),
		.testTarget(
			name: "StatisticsDetailsFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsDetailsFeature",
			]
		),
		.target(
			name: "StatisticsOverviewFeature",
			dependencies: [
				"StatisticsDetailsFeature",
			]
		),
		.testTarget(
			name: "StatisticsOverviewFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsOverviewFeature",
			]
		),
		.target(
			name: "StatisticsWidgetEditorFeature",
			dependencies: [
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"BowlersRepositoryInterface",
				"ErrorsFeature",
				"LeaguesRepositoryInterface",
				"ModelsViewsLibrary",
				"PickableModelsLibrary",
				"StatisticsWidgetsRepositoryInterface",
			]
		),
		.testTarget(
			name: "StatisticsWidgetEditorFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsWidgetEditorFeature",
			]
		),
		.target(
			name: "StatisticsWidgetsLayoutFeature",
			dependencies: [
				"ReorderingLibrary",
				"StatisticsDetailsFeature",
			]
		),
		.testTarget(
			name: "StatisticsWidgetsLayoutFeatureTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsWidgetsLayoutFeature",
			]
		),

		// MARK: - Repositories
		.target(
			name: "AlleysRepository",
			dependencies: [
				"AlleysRepositoryInterface",
				"DatabaseServiceInterface",
				"RecentlyUsedServiceInterface",
				"RepositoryLibrary",
				"StatisticsModelsLibrary",
			]
		),
		.target(
			name: "AlleysRepositoryInterface",
			dependencies: [
				"LanesRepositoryInterface",
				"LocationsRepositoryInterface",
			]
		),
		.testTarget(
			name: "AlleysRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"AlleysRepository",
				"DatabaseService",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "BowlersRepository",
			dependencies: [
				"BowlersRepositoryInterface",
				"DatabaseServiceInterface",
				"RecentlyUsedServiceInterface",
				"RepositoryLibrary",
				"StatisticsModelsLibrary",
			]
		),
		.target(
			name: "BowlersRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "BowlersRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"BowlersRepository",
				"DatabaseService",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "FramesRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"FramesRepositoryInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "FramesRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"ModelsLibrary",
				"ScoreKeeperLibrary",
			]
		),
		.testTarget(
			name: "FramesRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"FramesRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "GamesRepository",
			dependencies: [
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"GamesRepositoryInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "GamesRepositoryInterface",
			dependencies: [
				"MatchPlaysRepositoryInterface",
			]
		),
		.testTarget(
			name: "GamesRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"GamesRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "GearRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"GearRepositoryInterface",
				"RecentlyUsedServiceInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "GearRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "GearRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"GearRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "LanesRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"LanesRepositoryInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "LanesRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "LanesRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"LanesRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "LeaguesRepository",
			dependencies: [
				"DatabaseServiceInterface",
				"LeaguesRepositoryInterface",
				"RecentlyUsedServiceInterface",
				"RepositoryLibrary",
				"StatisticsModelsLibrary",
			]
		),
		.target(
			name: "LeaguesRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "LeaguesRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"LeaguesRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "LocationsRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"LocationsRepositoryInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "LocationsRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "LocationsRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"LocationsRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "MatchPlaysRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"MatchPlaysRepositoryInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "MatchPlaysRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "MatchPlaysRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"MatchPlaysRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "QuickLaunchRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"LeaguesRepositoryInterface",
				"QuickLaunchRepositoryInterface",
				"RecentlyUsedServiceInterface",
				"RepositoryLibrary",
			]
		),
		.target(
			name: "QuickLaunchRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "QuickLaunchRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"QuickLaunchRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "ScoresRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"FramesRepositoryInterface",
				"GamesRepositoryInterface",
				"RepositoryLibrary",
				"ScoresRepositoryInterface",
			]
		),
		.target(
			name: "ScoresRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "ScoresRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"FramesRepository",
				"GamesRepository",
				"ScoresRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "SeriesRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"RepositoryLibrary",
				"SeriesRepositoryInterface",
			]
		),
		.target(
			name: "SeriesRepositoryInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "SeriesRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"SeriesRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "StatisticsRepository",
			dependencies: [
				.product(name: "UserDefaultsPackageServiceInterface", package: "swift-utilities"),
				"DatabaseServiceInterface",
				"FeatureFlagsLibrary",
				"PreferenceServiceInterface",
				"RecentlyUsedServiceInterface",
				"RepositoryLibrary",
				"StatisticsModelsLibrary",
				"StatisticsRepositoryInterface",
			]
		),
		.target(
			name: "StatisticsRepositoryInterface",
			dependencies: [
				.product(name: "Collections", package: "swift-collections"),
				"StatisticsWidgetsLibrary",
			]
		),
		.testTarget(
			name: "StatisticsRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"StatisticsRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "StatisticsWidgetsRepository",
			dependencies: [
				"DatabaseModelsLibrary",
				"DatabaseServiceInterface",
				"RepositoryLibrary",
				"StatisticsWidgetsRepositoryInterface",
			]
		),
		.target(
			name: "StatisticsWidgetsRepositoryInterface",
			dependencies: [
				"StatisticsRepositoryInterface",
			]
		),
		.testTarget(
			name: "StatisticsWidgetsRepositoryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				.product(name: "TestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseService",
				"StatisticsRepository",
				"StatisticsWidgetsRepository",
				"TestDatabaseUtilitiesLibrary",
			]
		),

		// MARK: - Data Providers

		// MARK: - Services
		.target(
			name: "AddressLookupService",
			dependencies: [
				"AddressLookupServiceInterface",
			]
		),
		.target(
			name: "AddressLookupServiceInterface",
			dependencies: [
				.product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "EquatablePackageLibrary", package: "swift-utilities"),
				.product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
				"ModelsLibrary",
			]
		),
		.testTarget(
			name: "AddressLookupServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AddressLookupService",
			]
		),
		.target(
			name: "AnalyticsService",
			dependencies: [
				.product(name: "Sentry", package: "sentry-cocoa"),
				"AnalyticsServiceInterface",
			]
		),
		.target(
			name: "AnalyticsServiceInterface",
			dependencies: [
				.product(name: "AnalyticsPackageServiceInterface", package: "swift-utilities"),
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				.product(name: "ErrorReportingClientPackageLibrary", package: "swift-utilities"),
			]
		),
		.testTarget(
			name: "AnalyticsServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AnalyticsService",
			]
		),
		.target(
			name: "AppIconService",
			dependencies: [
				"AppIconServiceInterface",
			]
		),
		.target(
			name: "AppIconServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"AssetsLibrary",
			]
		),
		.target(
			name: "AvatarService",
			dependencies: [
				.product(name: "ExtensionsPackageLibrary", package: "swift-utilities"),
				"AvatarServiceInterface",
			]
		),
		.target(
			name: "AvatarServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ModelsViewsLibrary",
			]
		),
		.testTarget(
			name: "AvatarServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"AvatarService",
			]
		),
		.target(
			name: "DatabaseMockingService",
			dependencies: [
				"DatabaseMockingServiceInterface",
			]
		),
		.target(
			name: "DatabaseMockingServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
		.target(
			name: "DatabaseService",
			dependencies: [
				.product(name: "FileManagerPackageServiceInterface", package: "swift-utilities"),
				"DatabaseMigrationsLibrary",
				"DatabaseServiceInterface",
			]
		),
		.target(
			name: "DatabaseServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
				.product(name: "GRDB", package: "GRDB.swift"),
				.product(name: "GRDBDatabasePackageServiceInterface", package: "swift-utilities"),
			]
		),
		.testTarget(
			name: "DatabaseServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"DatabaseService",
			]
		),
		.target(
			name: "EmailService",
			dependencies: [
				"EmailServiceInterface",
			]
		),
		.target(
			name: "EmailServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "EmailServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"EmailService",
			]
		),
		.target(
			name: "ImportExportService",
			dependencies: [
				.product(name: "FileManagerPackageServiceInterface", package: "swift-utilities"),
				"DatabaseServiceInterface",
				"DateTimeLibrary",
				"ImportExportServiceInterface",
			]
		),
		.target(
			name: "ImportExportServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "ImportExportServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ImportExportService",
			]
		),
		.target(
			name: "LaunchService",
			dependencies: [
				.product(name: "AppInfoPackageServiceInterface", package: "swift-utilities"),
				.product(name: "StoreReviewPackageServiceInterface", package: "swift-utilities"),
				.product(name: "UserDefaultsPackageServiceInterface", package: "swift-utilities"),
				"AnalyticsServiceInterface",
				"FeatureFlagsLibrary",
				"LaunchServiceInterface",
				"PreferenceServiceInterface",
				"ProductsServiceInterface",
			]
		),
		.target(
			name: "LaunchServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "LaunchServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"LaunchService",
			]
		),
		.target(
			name: "LoggingService",
			dependencies: [
				.product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
				.product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
				"LoggingServiceInterface",
				"ZIPServiceInterface",
			]
		),
		.target(
			name: "LoggingServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "LoggingServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"LoggingService",
			]
		),
		.target(
			name: "NotificationsService",
			dependencies: [
				"NotificationsServiceInterface",
			]
		),
		.target(
			name: "NotificationsServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "NotificationsServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"NotificationsService",
			]
		),
		.target(
			name: "PreferenceService",
			dependencies: [
				.product(name: "UserDefaultsPackageServiceInterface", package: "swift-utilities"),
				"PreferenceServiceInterface",
			]
		),
		.target(
			name: "PreferenceServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "PreferenceServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"PreferenceService",
			]
		),
		.target(
			name: "ProductsService",
			dependencies: [
				.product(name: "BundlePackageServiceInterface", package: "swift-utilities"),
				"ConstantsLibrary",
				"ProductsServiceInterface",
			]
		),
		.target(
			name: "ProductsServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"ProductsLibrary",
			]
		),
		.testTarget(
			name: "ProductsServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ProductsService",
			]
		),
		.target(
			name: "RecentlyUsedService",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms"),
				.product(name: "UserDefaultsPackageServiceInterface", package: "swift-utilities"),
				"RecentlyUsedServiceInterface",
			]
		),
		.target(
			name: "RecentlyUsedServiceInterface",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "Dependencies", package: "swift-dependencies"),
				"StatisticsLibrary",
			]
		),
		.testTarget(
			name: "RecentlyUsedServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"RecentlyUsedService",
			]
		),
		.target(
			name: "TipsService",
			dependencies: [
				.product(name: "UserDefaultsPackageServiceInterface", package: "swift-utilities"),
				"TipsServiceInterface",
			]
		),
		.target(
			name: "TipsServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"TipsLibrary",
			]
		),
		.testTarget(
			name: "TipsServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"TipsService",
			]
		),
		.target(
			name: "ZIPService",
			dependencies: [
				.product(name: "FileManagerPackageServiceInterface", package: "swift-utilities"),
				.product(name: "ZIPFoundation", package: "ZIPFoundation"),
				"ZIPServiceInterface",
			]
		),
		.target(
			name: "ZIPServiceInterface",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "DependenciesMacros", package: "swift-dependencies"),
			]
		),
		.testTarget(
			name: "ZIPServiceTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ZIPService",
			]
		),

		// MARK: - Libraries
		.target(
			name: "AssetsLibrary",
			dependencies: [
				.product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
			],
			resources: [
				.process("Resources"),
			]
		),
		.target(
			name: "ComposableExtensionsLibrary",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "IdentifiedCollections", package: "swift-identified-collections"),
			]
		),
		.target(
			name: "ConstantsLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"StringsLibrary",
			],
			resources: [
				.process("Resources"),
			]
		),
		.target(
			name: "DatabaseMigrationsLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "ErrorReportingClientPackageLibrary", package: "swift-utilities"),
				.product(name: "GRDB", package: "GRDB.swift"),
				.product(name: "GRDBDatabasePackageLibrary", package: "swift-utilities"),
				"ScoreKeeperLibrary",
			]
		),
		.target(
			name: "DatabaseModelsLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "GRDB", package: "GRDB.swift"),
				"ModelsLibrary",
			]
		),
		.target(
			name: "DateTimeLibrary",
			dependencies: []
		),
		.testTarget(
			name: "DateTimeLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"DateTimeLibrary",
			]
		),
		.target(
			name: "FeatureActionLibrary",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.target(
			name: "FeatureFlagsLibrary",
			dependencies: [
				.product(name: "FeatureFlagsPackageLibrary", package: "swift-utilities"),
				.product(name: "FeatureFlagsPackageServiceInterface", package: "swift-utilities"),
			]
		),
		.target(
			name: "ListContentLibrary",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "ListContentLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ListContentLibrary",
			]
		),
		.target(
			name: "ModelsLibrary",
			dependencies: [
				.product(name: "IdentifiedCollections", package: "swift-identified-collections"),
				"ScoreKeeperModelsLibrary",
			]
		),
		.testTarget(
			name: "ModelsLibraryTests",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ModelsLibrary",
			]
		),
		.target(
			name: "ModelsViewsLibrary",
			dependencies: [
				"AssetsLibrary",
				"ModelsLibrary",
				"StringsLibrary",
			]
		),
		.testTarget(
			name: "ModelsViewsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ModelsViewsLibrary",
			]
		),
		.target(
			name: "PickableModelsLibrary",
			dependencies: [
				"ModelsLibrary",
				"ResourcePickerLibrary",
			]
		),
		.testTarget(
			name: "PickableModelsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"PickableModelsLibrary",
			]
		),
		.target(
			name: "ProductsLibrary",
			dependencies: []
		),
		.target(
			name: "ReorderingLibrary",
			dependencies: [
				.product(name: "IdentifiedCollections", package: "swift-identified-collections"),
				"FeatureActionLibrary",
			]
		),
		.testTarget(
			name: "ReorderingLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ReorderingLibrary",
			]
		),
		.target(
			name: "RepositoryLibrary",
			dependencies: [
				.product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
				"SortingLibrary",
			]
		),
		.testTarget(
			name: "RepositoryLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"RepositoryLibrary",
			]
		),
		.target(
			name: "ResourceListLibrary",
			dependencies: [
				.product(name: "EquatablePackageLibrary", package: "swift-utilities"),
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"ComposableExtensionsLibrary",
				"FeatureActionLibrary",
				"ListContentLibrary",
			]
		),
		.testTarget(
			name: "ResourceListLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ResourceListLibrary",
			]
		),
		.target(
			name: "ResourcePickerLibrary",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"ComposableExtensionsLibrary",
				"FeatureActionLibrary",
				"ListContentLibrary",
			]
		),
		.testTarget(
			name: "ResourcePickerLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ResourcePickerLibrary",
			]
		),
		.target(
			name: "ScoreKeeperLibrary",
			dependencies: [
				"ScoreKeeperModelsLibrary",
			]
		),
		.testTarget(
			name: "ScoreKeeperLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ScoreKeeperLibrary",
			]
		),
		.target(
			name: "ScoreKeeperModelsLibrary",
			dependencies: []
		),
		.testTarget(
			name: "ScoreKeeperModelsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ScoreKeeperModelsLibrary",
			]
		),
		.target(
			name: "ScoreSheetLibrary",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"ModelsLibrary",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "ScoreSheetLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ScoreSheetLibrary",
			]
		),
		.target(
			name: "SortOrderLibrary",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"FeatureActionLibrary",
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "SortOrderLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SortOrderLibrary",
			]
		),
		.target(
			name: "SortingLibrary",
			dependencies: []
		),
		.testTarget(
			name: "SortingLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"SortingLibrary",
			]
		),
		.target(
			name: "StatisticsChartsLibrary",
			dependencies: [
				.product(name: "SwiftUIExtensionsPackageLibrary", package: "swift-utilities"),
				"AssetsLibrary",
				"DateTimeLibrary",
				"StatisticsLibrary",
			]
		),
		.testTarget(
			name: "StatisticsChartsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsChartsLibrary",
			]
		),
		.target(
			name: "StatisticsChartsMocksLibrary",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				"StatisticsChartsLibrary",
			]
		),
		.target(
			name: "StatisticsLibrary",
			dependencies: [
				"ModelsLibrary",
				"StringsLibrary",
			]
		),
		.testTarget(
			name: "StatisticsLibraryTests",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies"),
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsLibrary",
			]
		),
		.target(
			name: "StatisticsModelsLibrary",
			dependencies: [
				"DatabaseModelsLibrary",
				"StatisticsLibrary",
			]
		),
		.testTarget(
			name: "StatisticsModelsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"DatabaseService",
				"StatisticsModelsLibrary",
				"TestDatabaseUtilitiesLibrary",
			]
		),
		.target(
			name: "StatisticsWidgetsLibrary",
			dependencies: [
				"StatisticsChartsMocksLibrary",
			]
		),
		.testTarget(
			name: "StatisticsWidgetsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StatisticsWidgetsLibrary",
			]
		),
		.target(
			name: "StringsLibrary",
			dependencies: []
		),
		.testTarget(
			name: "StringsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"StringsLibrary",
			]
		),
		.target(
			name: "TestDatabaseUtilitiesLibrary",
			dependencies: [
				.product(name: "GRDBDatabaseTestUtilitiesPackageLibrary", package: "swift-utilities"),
				"DatabaseMigrationsLibrary",
				"DatabaseModelsLibrary",
			]
		),
		.target(
			name: "TipsLibrary",
			dependencies: [
				"ViewsLibrary",
			]
		),
		.testTarget(
			name: "TipsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"TipsLibrary",
			]
		),
		.target(
			name: "ToastLibrary",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "ToastUI", package: "ToastUI"),
				"AssetsLibrary",
			]
		),
		.testTarget(
			name: "ToastLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ToastLibrary",
			]
		),
		.target(
			name: "ViewsLibrary",
			dependencies: [
				"AssetsLibrary",
				"StringsLibrary",
			]
		),
		.testTarget(
			name: "ViewsLibraryTests",
			dependencies: [
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
				"ViewsLibrary",
			]
		),
	]
)
