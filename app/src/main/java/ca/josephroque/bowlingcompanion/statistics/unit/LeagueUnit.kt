package ca.josephroque.bowlingcompanion.statistics.unit

import android.content.Context
import android.os.Parcel
import android.os.Parcelable
import ca.josephroque.bowlingcompanion.common.interfaces.parcelableCreator
import ca.josephroque.bowlingcompanion.leagues.League
import ca.josephroque.bowlingcompanion.statistics.StatisticsCategory
import ca.josephroque.bowlingcompanion.statistics.impl.general.GameNameStatistic
import ca.josephroque.bowlingcompanion.statistics.impl.general.SeriesNameStatistic
import ca.josephroque.bowlingcompanion.statistics.list.StatisticListItem
import kotlinx.coroutines.experimental.CommonPool
import kotlinx.coroutines.experimental.Deferred
import kotlinx.coroutines.experimental.async

/**
 * Copyright (C) 2018 Joseph Roque
 *
 * A [League] whose statistics can be loaded and displayed.
 */
class LeagueUnit(val leagueId: Long, leagueName: String, parcel: Parcel? = null) : StatisticsUnit(parcel) {

    // MARK: Overrides

    override val name: String = leagueName
    override val excludedCategories: Set<StatisticsCategory> = emptySet()
    override val excludedStatisticIds: Set<Int> = setOf(SeriesNameStatistic.Id, GameNameStatistic.Id)

    // MARK: StatisticsUnit

    /** @Override */
    override fun buildStatistics(context: Context): Deferred<MutableList<StatisticListItem>> {
        // TODO: build league statistics
        return async(CommonPool) {
            return@async emptyList<StatisticListItem>().toMutableList()
        }
    }

    // MARK: KParcelable

    /** @Override */
    override fun writeToParcel(dest: Parcel, flags: Int) = with(dest) {
        writeLong(leagueId)
        writeString(name)
        writeStatisticsToParcel(this)
    }

    /**
     * Construct a [LeagueUnit] from a [Parcel].
     */
    private constructor(p: Parcel): this(
            leagueId = p.readLong(),
            leagueName = p.readString(),
            parcel = p
    )

    companion object {
        /** Logging identifier */
        @Suppress("unused")
        private const val TAG = "LeagueUnit"

        /** Creator, required by [Parcelable]. */
        @Suppress("unused")
        @JvmField val CREATOR = parcelableCreator(::LeagueUnit)
    }
}
