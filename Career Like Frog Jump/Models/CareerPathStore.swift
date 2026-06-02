import Foundation

@MainActor
final class CareerPathStore: ObservableObject {
    @Published var selectedTab: AppTab = .lilyPadMap
    @Published var globalGoalTitle: String?
    @Published var tasks: [LilyPadTaskItem] = []
    @Published var isEditingGoalInline = false
    @Published var isPresentingTaskCreation = false
    @Published var taskCreationDraft = PlaceLilyPadDraft()
    @Published var goalCreationDraft = ""
    @Published var halfHearts: Int = FrogHeartDisplay.maxHalfHearts
    @Published var flyCoins: Int = 0
    @Published var isPresentingJumpTask = false
    @Published var jumpTaskComment = ""
    @Published var activeJumpTaskID: UUID?
    @Published var frogSlotIndex: Int = -1
    @Published var jumpAnimation: RiverJumpAnimation?

    var hasGlobalGoal: Bool {
        guard let globalGoalTitle else { return false }
        return !globalGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var shouldShowInlineGoalForm: Bool {
        !hasGlobalGoal || isEditingGoalInline
    }

    var riverTasks: [LilyPadTaskItem] {
        Array(tasks.prefix(RiverElementLayoutConfig.maxTaskCount))
    }

    var incompleteTasks: [LilyPadTaskItem] {
        tasks.filter { !$0.isCompleted }
    }

    var isJumpAnimating: Bool {
        jumpAnimation != nil
    }

    var activeJumpTask: LilyPadTaskItem? {
        guard let activeJumpTaskID else { return nil }
        return tasks.first { $0.id == activeJumpTaskID }
    }

    func requestGoalCreation() {
        goalCreationDraft = globalGoalTitle ?? ""
        isEditingGoalInline = true
        selectedTab = .lilyPadMap
    }

    func saveGlobalGoal() {
        let title = goalCreationDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        globalGoalTitle = title
        isEditingGoalInline = false
        goalCreationDraft = ""
    }

    func cancelInlineGoalEditing() {
        isEditingGoalInline = false
        if !hasGlobalGoal {
            goalCreationDraft = ""
        } else {
            goalCreationDraft = globalGoalTitle ?? ""
        }
    }

    func presentTaskCreation() {
        taskCreationDraft = PlaceLilyPadDraft()
        isPresentingTaskCreation = true
    }

    func cancelTaskCreation() {
        isPresentingTaskCreation = false
        taskCreationDraft = PlaceLilyPadDraft()
    }

    func updateTaskCreationTitle(_ value: String) {
        if value.count > PlaceLilyPadDraft.titleCharacterLimit {
            taskCreationDraft.title = String(value.prefix(PlaceLilyPadDraft.titleCharacterLimit))
        } else {
            taskCreationDraft.title = value
        }
    }

    func saveTaskCreation() {
        guard taskCreationDraft.isValid else { return }

        let task = LilyPadTaskItem(
            title: taskCreationDraft.trimmedTitle,
            category: taskCreationDraft.category,
            deadline: taskCreationDraft.deadline,
            importance: taskCreationDraft.importance
        )
        tasks.append(task)
        cancelTaskCreation()
    }

    func deleteTask(_ task: LilyPadTaskItem) {
        tasks.removeAll { $0.id == task.id }
    }

    func delegateTask(_ task: LilyPadTaskItem) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDelegated = true
    }

    func presentJumpTask() {
        guard !isJumpAnimating, incompleteTasks.first != nil else { return }
        guard let task = incompleteTasks.first else { return }
        activeJumpTaskID = task.id
        jumpTaskComment = ""
        isPresentingJumpTask = true
    }

    func cancelJumpTask() {
        isPresentingJumpTask = false
        activeJumpTaskID = nil
        jumpTaskComment = ""
    }

    func completeJumpTask() {
        guard !isJumpAnimating,
              let taskID = activeJumpTaskID,
              let taskIndex = tasks.firstIndex(where: { $0.id == taskID }),
              !tasks[taskIndex].isCompleted else { return }

        guard let riverSlotIndex = riverTasks.firstIndex(where: { $0.id == taskID }) else { return }

        let comment = jumpTaskComment.trimmingCharacters(in: .whitespacesAndNewlines)
        tasks[taskIndex].isCompleted = true
        tasks[taskIndex].completionComment = comment.isEmpty ? nil : comment
        flyCoins += tasks[taskIndex].importance.flyCoinReward

        isPresentingJumpTask = false
        activeJumpTaskID = nil
        jumpTaskComment = ""

        jumpAnimation = RiverJumpAnimation(
            fromSlotIndex: frogSlotIndex,
            toSlotIndex: riverSlotIndex
        )
    }

    func finishJumpAnimation() {
        guard let jumpAnimation else { return }
        frogSlotIndex = jumpAnimation.toSlotIndex
        self.jumpAnimation = nil
    }

    func takeDamage(halfHearts amount: Int = 1) {
        halfHearts = max(0, halfHearts - amount)
    }

    func requestGoalEdit() {
        goalCreationDraft = globalGoalTitle ?? ""
        isEditingGoalInline = true
    }

    func updateGoalDraft(_ value: String) {
        if value.count > 60 {
            goalCreationDraft = String(value.prefix(60))
        } else {
            goalCreationDraft = value
        }
    }
}

extension CareerPathStore {
    static var previewWithGoalAndTasks: CareerPathStore {
        let store = CareerPathStore()
        store.globalGoalTitle = "Senior Developer"
        store.tasks = [
            LilyPadTaskItem(title: "Course", category: .hardSkills, deadline: Date(), importance: .medium),
            LilyPadTaskItem(title: "Mentor", category: .networking, deadline: Date(), importance: .high)
        ]
        return store
    }
}
