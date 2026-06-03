import Foundation

struct JumpStat: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

@MainActor
final class JumpStatisticsViewModel: ObservableObject {
    @Published var stats: [JumpStat] = []
    @Published var weeklyJumpWeeks: [WeeklyJumpDataPoint] = []
    @Published var categorySlices: [CategoryEffortSlice] = []

    func refresh(from store: CareerPathStore) {
        weeklyJumpWeeks = JumpStatisticsAnalytics.weeklyJumpPoints(
            from: store.jumpCompletionTimestamps
        )
        categorySlices = JumpStatisticsAnalytics.categoryEffortSlices(
            currentTasks: store.tasks,
            completedGoals: store.completedGoals
        )
        stats = [
            JumpStat(label: "Jumps completed", value: "\(store.jumpsCompleted)"),
            JumpStat(label: "Threats beaten", value: "\(store.threatsDefeated)"),
            JumpStat(label: "Goals completed", value: "\(store.completedGoals.count)"),
            JumpStat(label: "Fly coins", value: "\(store.flyCoins)")
        ]
    }
}
