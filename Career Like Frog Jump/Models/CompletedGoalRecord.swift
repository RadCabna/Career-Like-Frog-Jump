import Foundation

struct CompletedGoalRecord: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let title: String
    let completedAt: Date
    let tasks: [LilyPadTaskItem]

    init(
        id: UUID = UUID(),
        title: String,
        completedAt: Date = Date(),
        tasks: [LilyPadTaskItem]
    ) {
        self.id = id
        self.title = title
        self.completedAt = completedAt
        self.tasks = tasks
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var progressSummary: String {
        let completedCount = tasks.filter { $0.isCompleted && !$0.isDelegated && !$0.isDeleted }.count
        let deletedCount = tasks.filter(\.isDeleted).count
        let delegatedCount = tasks.filter { $0.isDelegated && !$0.isDeleted }.count

        var parts = ["\(completedCount) completed"]
        if deletedCount > 0 {
            parts.append("\(deletedCount) deleted")
        }
        if delegatedCount > 0 {
            parts.append("\(delegatedCount) delegated")
        }
        return parts.joined(separator: " · ")
    }
}
