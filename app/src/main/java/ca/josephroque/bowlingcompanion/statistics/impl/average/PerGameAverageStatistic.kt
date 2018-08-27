package ca.josephroque.bowlingcompanion.statistics.impl.average

import ca.josephroque.bowlingcompanion.statistics.AverageStatistic
import ca.josephroque.bowlingcompanion.statistics.StatisticsCategory
import ca.josephroque.bowlingcompanion.statistics.immutable.StatGame

/**
 * Copyright (C) 2018 Joseph Roque
 *
 * Average score in the nth game of a series.
 */
abstract class PerGameAverageStatistic(override var total: Int, override var divisor: Int) : AverageStatistic {

    // MARK: Modifiers

    /** @Override */
    override fun modify(game: StatGame) {
        if (game.ordinal == gameNumber) {
            divisor++
            total += game.score
        }
    }

    // MARK: Overrides

    override val category = StatisticsCategory.Average
    override fun isModifiedBy(game: StatGame) = true

    // MARK: PerGameAverageStatistic

    /** Number of game in the series. */
    abstract val gameNumber: Int
}
