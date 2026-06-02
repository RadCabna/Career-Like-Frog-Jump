import Foundation

struct LilyPadTaskItem: Identifiable, Equatable {
    let id: UUID
    var title: String
    var category: LilyPadCategory
    var deadline: Date
    var importance: LilyPadImportance
    var isCompleted: Bool
    var isDelegated: Bool
    var completionComment: String?

    init(
        id: UUID = UUID(),
        title: String,
        category: LilyPadCategory,
        deadline: Date,
        importance: LilyPadImportance,
        isCompleted: Bool = false,
        isDelegated: Bool = false,
        completionComment: String? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.deadline = deadline
        self.importance = importance
        self.isCompleted = isCompleted
        self.isDelegated = isDelegated
        self.completionComment = completionComment
    }

    var isOverdue: Bool {
        !isCompleted && deadline < Date()
    }
}
