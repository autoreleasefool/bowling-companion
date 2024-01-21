pluginManagement {
	includeBuild("build-logic")
	repositories {
		google()
		mavenCentral()
		gradlePluginPortal()
	}
}
dependencyResolutionManagement {
	@Suppress("UnstableApiUsage")
	repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
	@Suppress("UnstableApiUsage")
	repositories {
		google()
		mavenCentral()
		maven { url = uri("https://jitpack.io") }
	}
}

rootProject.name = "Approach"
include(":app")
include(":core:analytics")
include(":core:charts")
include(":core:common")
include(":core:data")
include(":core:database")
include(":core:datastore")
include(":core:designsystem")
include(":core:featureflags")
include(":core:model")
include(":core:model:ui")
include(":core:navigation")
include(":core:scoresheet")
include(":core:scoring")
include(":core:statistics")
include(":core:statistics:charts")
include(":core:testing")
include(":feature:accessoriesoverview")
include(":feature:accessoriesoverview:ui")
include(":feature:alleyform")
include(":feature:alleyform:ui")
include(":feature:alleyslist")
include(":feature:alleyslist:ui")
include(":feature:archives")
include(":feature:archives:ui")
include(":feature:avatarform")
include(":feature:avatarform:ui")
include(":feature:bowlerdetails")
include(":feature:bowlerdetails:ui")
include(":feature:bowlerform")
include(":feature:bowlerform:ui")
include(":feature:bowlerslist:ui")
include(":feature:datamanagement")
include(":feature:datamanagement:ui")
include(":feature:gameseditor")
include(":feature:gameseditor:ui")
include(":feature:gameslist:ui")
include(":feature:gearform")
include(":feature:gearform:ui")
include(":feature:gearlist")
include(":feature:gearlist:ui")
include(":feature:laneform")
include(":feature:laneform:ui")
include(":feature:laneslist:ui")
include(":feature:leaguedetails")
include(":feature:leaguedetails:ui")
include(":feature:leagueform")
include(":feature:leagueform:ui")
include(":feature:leagueslist:ui")
include(":feature:matchplayeditor")
include(":feature:matchplayeditor:ui")
include(":feature:onboarding")
include(":feature:onboarding:ui")
include(":feature:opponentslist")
include(":feature:opponentslist:ui")
include(":feature:overview")
include(":feature:overview:ui")
include(":feature:resourcepicker")
include(":feature:resourcepicker:ui")
include(":feature:seriesdetails")
include(":feature:seriesdetails:ui")
include(":feature:seriesform")
include(":feature:seriesform:ui")
include(":feature:serieslist:ui")
include(":feature:settings")
include(":feature:settings:ui")
include(":feature:statisticsdetails")
include(":feature:statisticsdetails:ui")
include(":feature:statisticsoverview")
include(":feature:statisticsoverview:ui")
include(":feature:statisticswidget")
include(":feature:statisticswidget:ui")