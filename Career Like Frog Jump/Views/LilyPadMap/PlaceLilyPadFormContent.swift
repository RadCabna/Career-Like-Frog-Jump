import SwiftUI

struct PlaceLilyPadFormContent: View {
    let title: String
    @Binding var draft: PlaceLilyPadDraft
    let onTitleChange: (String) -> Void
    let onCancel: () -> Void
    let onSave: () -> Void
    let isSaveEnabled: Bool

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
                .listRowBackground(Color.clear)
            } header: {
                Text(title)
            }

            Section("Support Category") {
                ForEach(LilyPadCategory.allCases) { category in
                    CategorySelectionRow(
                        category: category,
                        isSelected: draft.category == category
                    ) {
                        draft.category = category
                    }
                }
            }

            Section("Deadline") {
                DatePicker(
                    "Date and time",
                    selection: $draft.deadline,
                    displayedComponents: [.date, .hourAndMinute]
                )
            }

            Section("Importance") {
                Picker("Importance", selection: $draft.importance) {
                    ForEach(LilyPadImportance.allCases) { level in
                        Text(level.title).tag(level)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Element size")
                    Spacer()
                    Text(importanceSizeLabel)
                        .foregroundStyle(.secondary)
                }

                HStack {
                    Text("Fly coin reward")
                    Spacer()
                    Text("+\(draft.importance.flyCoinReward)")
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.gold)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
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
                    Text("\(category.title) (\(category.supportMetaphor))")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(category.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
