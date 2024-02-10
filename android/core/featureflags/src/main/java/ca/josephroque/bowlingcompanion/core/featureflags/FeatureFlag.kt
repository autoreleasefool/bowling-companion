package ca.josephroque.bowlingcompanion.core.featureflags

enum class RolloutStage {
	DISABLED,
	DEVELOPMENT,
	TEST,
	RELEASE,
}

interface Feature {
	val key: String
	val introduced: String
	val rolloutStage: RolloutStage
}

enum class FeatureFlag(
	override val key: String,
	override val introduced: String,
	override val rolloutStage: RolloutStage,
): Feature {
	DATA_EXPORT("DataExport", "2023-10-12", RolloutStage.RELEASE),
	DATA_IMPORT("DataImport", "2023-10-13", RolloutStage.RELEASE),
}

fun FeatureFlag.isEnabled(): Boolean = if (BuildConfig.DEBUG) {
	this.rolloutStage >= RolloutStage.DEVELOPMENT
} else {
		this.rolloutStage == RolloutStage.RELEASE
}