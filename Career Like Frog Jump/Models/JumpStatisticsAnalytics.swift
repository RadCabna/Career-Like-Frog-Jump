import Foundation

struct WeeklyJumpDataPoint: Identifiable, Equatable {
    let id: Int
    let weekStart: Date
    let shortLabel: String
    let jumpCount: Int

    var isIdleWeek: Bool { jumpCount == 0 }
}

struct CategoryEffortSlice: Identifiable, Equatable {
    let category: LilyPadCategory
    let completedCount: Int
    let totalCompleted: Int

    var id: String { category.id }

    var share: Double {
        guard totalCompleted > 0 else { return 0 }
        return Double(completedCount) / Double(totalCompleted)
    }
}

enum JumpStatisticsAnalytics {
    static let displayedWeekCount = 8

    static func weeklyJumpPoints(
        from timestamps: [Date],
        weekCount: Int = displayedWeekCount,
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> [WeeklyJumpDataPoint] {
        guard
            weekCount > 0,
            let thisWeekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start
        else { return [] }

        return (0..<weekCount).reversed().enumerated().map { index, weeksAgo in
            let weekStart = calendar.date(byAdding: .weekOfYear, value: -weeksAgo, to: thisWeekStart) ?? thisWeekStart
            let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) ?? weekStart
            let count = timestamps.filter { $0 >= weekStart && $0 < weekEnd }.count
            return WeeklyJumpDataPoint(
                id: index,
                weekStart: weekStart,
                shortLabel: shortWeekLabel(for: weekStart, calendar: calendar),
                jumpCount: count
            )
        }
    }

    static func categoryEffortSlices(
        currentTasks: [LilyPadTaskItem],
        completedGoals: [CompletedGoalRecord]
    ) -> [CategoryEffortSlice] {
        var counts: [LilyPadCategory: Int] = [:]
        for category in LilyPadCategory.allCases {
            counts[category] = 0
        }

        func countCompleted(_ task: LilyPadTaskItem) {
            guard task.isCompleted else { return }
            counts[task.category, default: 0] += 1
        }

        currentTasks.forEach(countCompleted)
        completedGoals.flatMap(\.tasks).forEach(countCompleted)

        let totalCompleted = counts.values.reduce(0, +)
        return LilyPadCategory.allCases.map { category in
            CategoryEffortSlice(
                category: category,
                completedCount: counts[category, default: 0],
                totalCompleted: totalCompleted
            )
        }
    }

    private static func shortWeekLabel(for weekStart: Date, calendar: Calendar) -> String {
        let month = weekStart.formatted(.dateTime.month(.abbreviated))
        let day = calendar.component(.day, from: weekStart)
        return "\(month) \(day)"
    }
}
