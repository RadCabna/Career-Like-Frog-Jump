import Foundation

struct JumpStat: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

@MainActor
final class JumpStatisticsViewModel: ObservableObject {
    @Published var stats: [JumpStat] = [
        JumpStat(label: "Jumps this week", value: "14"),
        JumpStat(label: "Longest streak", value: "9 days"),
        JumpStat(label: "Threats dodged", value: "11"),
        JumpStat(label: "Shields activated", value: "3")
    ]

    @Published var weeklyJumpCounts: [Int] = [2, 3, 1, 4, 2, 1, 1]
}
