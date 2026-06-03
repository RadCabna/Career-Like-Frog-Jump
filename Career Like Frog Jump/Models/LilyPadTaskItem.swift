import Foundation

struct LilyPadTaskItem: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var category: LilyPadCategory
    var deadline: Date
    var importance: LilyPadImportance
    var isCompleted: Bool
    var isDelegated: Bool
    var isDeleted: Bool
    var completionComment: String?
    var microSteps: [String]

    init(
        id: UUID = UUID(),
        title: String,
        category: LilyPadCategory,
        deadline: Date,
        importance: LilyPadImportance,
        isCompleted: Bool = false,
        isDelegated: Bool = false,
        isDeleted: Bool = false,
        completionComment: String? = nil,
        microSteps: [String] = []
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.deadline = deadline
        self.importance = importance
        self.isCompleted = isCompleted
        self.isDelegated = isDelegated
        self.isDeleted = isDeleted
        self.completionComment = completionComment
        self.microSteps = microSteps
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        category = try container.decode(LilyPadCategory.self, forKey: .category)
        deadline = try container.decode(Date.self, forKey: .deadline)
        importance = try container.decode(LilyPadImportance.self, forKey: .importance)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        isDelegated = try container.decode(Bool.self, forKey: .isDelegated)
        isDeleted = try container.decodeIfPresent(Bool.self, forKey: .isDeleted) ?? false
        completionComment = try container.decodeIfPresent(String.self, forKey: .completionComment)
        microSteps = try container.decodeIfPresent([String].self, forKey: .microSteps) ?? []
    }

    var isOverdue: Bool {
        !isCompleted && !isDeleted && deadline < Date()
    }

    var progressReviewStatusLabels: [String] {
        var labels: [String] = []
        if isDeleted { labels.append("Deleted") }
        if isDelegated && !isDeleted { labels.append("Delegated") }
        if isCompleted { labels.append("Completed") }
        return labels
    }
}
