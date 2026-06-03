import SwiftUI

struct ReadOnlyTaskDetailView: View {
    let task: LilyPadTaskItem
    let onClose: () -> Void

    private var trimmedComment: String? {
        guard let raw = task.completionComment else { return nil }
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private var filledMicroSteps: [String] {
        task.microSteps
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task") {
                    Text(task.title)
                        .font(.body.weight(.semibold))
                }

                if let trimmedComment {
                    Section("Comment") {
                        Text(trimmedComment)
                            .font(.subheadline)
                    }
                }

                if !filledMicroSteps.isEmpty {
                    Section("Micro-steps") {
                        ForEach(Array(filledMicroSteps.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                                .font(.subheadline)
                        }
                    }
                }

                Section("Details") {
                    LabeledContent("Category", value: task.category.title)
                    LabeledContent("Deadline", value: task.deadline.formatted(date: .abbreviated, time: .shortened))
                    LabeledContent("Importance", value: task.importance.title)
                    if !task.progressReviewStatusLabels.isEmpty {
                        LabeledContent("Status", value: task.progressReviewStatusLabels.joined(separator: " · "))
                    }
                }
            }
            .navigationTitle(task.isCompleted ? "Task details" : "Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Close", action: onClose)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
