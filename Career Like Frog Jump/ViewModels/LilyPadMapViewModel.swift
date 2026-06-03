import Foundation

enum LilyPadSheetMode: Identifiable, Equatable {
    case create
    case edit(LilyPadTaskItem)

    var id: String {
        switch self {
        case .create: "create"
        case .edit(let task): task.id.uuidString
        }
    }

    var navigationTitle: String {
        switch self {
        case .create: "Place a Lily Pad"
        case .edit(let task): task.isCompleted ? "Task details" : "Edit Lily Pad"
        }
    }
}

@MainActor
final class LilyPadMapViewModel: ObservableObject {
    @Published var activeSheet: LilyPadSheetMode?
    @Published var draft = PlaceLilyPadDraft()

    func presentEditSheet(for task: LilyPadTaskItem) {
        draft = PlaceLilyPadDraft(
            title: task.title,
            category: task.category,
            deadline: task.deadline,
            importance: task.importance
        )
        activeSheet = .edit(task)
    }

    func saveDraft(for mode: LilyPadSheetMode, store: CareerPathStore) {
        guard draft.isValid else { return }

        switch mode {
        case .create:
            store.taskCreationDraft = draft
            store.saveTaskCreation()
        case .edit(let existing):
            guard let index = store.tasks.firstIndex(where: { $0.id == existing.id }) else { return }
            store.tasks[index].title = draft.trimmedTitle
            store.tasks[index].category = draft.category
            store.tasks[index].deadline = draft.deadline
            store.tasks[index].importance = draft.importance
        }

        activeSheet = nil
        draft = PlaceLilyPadDraft()
    }

    func cancelSheet() {
        activeSheet = nil
        draft = PlaceLilyPadDraft()
    }

    func updateTitleDraft(_ value: String) {
        if value.count > PlaceLilyPadDraft.titleCharacterLimit {
            draft.title = String(value.prefix(PlaceLilyPadDraft.titleCharacterLimit))
        } else {
            draft.title = value
        }
    }
}
