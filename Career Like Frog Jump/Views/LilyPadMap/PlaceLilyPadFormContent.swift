import SwiftUI

struct PlaceLilyPadFormContent: View {
    let title: String
    @Binding var draft: PlaceLilyPadDraft
    var microSteps: [String] = []
    var completionComment: String?
    let onTitleChange: (String) -> Void
    let onCancel: () -> Void
    let onSave: () -> Void
    let isSaveEnabled: Bool

    private var filledMicroSteps: [String] {
        microSteps
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        Form {
            Section {
                AppTextField(
                    title: "Task name",
                    placeholder: "Up to 40 characters",
                    text: Binding(
                        get: { draft.title },
                        set: onTitleChange
                    )
                )
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                .listRowBackground(Color.clear)

                HStack {
                    Spacer()
                    Text("\(draft.title.count)/\(PlaceLilyPadDraft.titleCharacterLimit)")
                        .font(.caption)
                        .foregroundStyle(
                            draft.title.count >= PlaceLilyPadDraft.titleCharacterLimit
                                ? AppColors.threatOrange
                                : .secondary
                        )
                }
                .listRowBackground(Color.white)
            }

            if let completionComment {
                Section("Comment") {
                    Text(completionComment)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.primaryLabel)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .listRowBackground(Color.white)
            }

            if !filledMicroSteps.isEmpty {
                Section("Micro-steps") {
                    ForEach(Array(filledMicroSteps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 10) {
                            Text("\(index + 1).")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(AppColors.neonGreen)
                                .frame(width: 22, alignment: .leading)

                            Text(step)
                                .font(.subheadline)
                                .foregroundStyle(AppColors.primaryLabel)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listRowBackground(Color.white)
            }

            Section("Support Category") {
                ForEach(LilyPadCategory.allCases) { category in
                    CategorySelectionRow(
                        category: category,
                        isSelected: draft.category == category
                    ) {
                        draft.category = category
                    }
                    .listRowBackground(Color.white)
                }
            }

            Section("Deadline") {
                DatePicker(
                    "Date and time",
                    selection: $draft.deadline,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .listRowBackground(Color.white)
            }

            Section("Importance") {
                Picker("Importance", selection: $draft.importance) {
                    ForEach(LilyPadImportance.allCases) { level in
                        Text(level.title).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.white)

                HStack {
                    Text("Element size")
                    Spacer()
                    Text(importanceSizeLabel)
                        .foregroundStyle(AppColors.secondaryLabel)
                }
                .listRowBackground(Color.white)

                HStack {
                    Text("Fly coin reward")
                    Spacer()
                    Text("+\(draft.importance.flyCoinReward)")
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.gold)
                }
                .listRowBackground(Color.white)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: onCancel)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: onSave)
                    .disabled(!isSaveEnabled)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.neonGreen)
            }
        }
    }

    private var importanceSizeLabel: String {
        switch draft.importance {
        case .low: "Small"
        case .medium: "Medium"
        case .high: "Large"
        }
    }
}

private struct CategorySelectionRow: View {
    let category: LilyPadCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(category.riverAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(category.pickerTitleLine)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(AppColors.primaryLabel)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                    Text(category.pickerSubtitleLine)
                        .font(.caption)
                        .foregroundStyle(AppColors.secondaryLabel)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppColors.neonGreen)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
