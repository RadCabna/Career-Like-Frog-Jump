import SwiftUI

struct JumpTaskSheetView: View {
    let task: LilyPadTaskItem
    @Binding var comment: String
    let onComplete: () -> Void
    let onCancel: () -> Void

    private var padSize: CGFloat {
        screenWidth * 0.16 * task.importance.padScale
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 14) {
                        Image(task.category.riverAssetName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: padSize)
                            .shadow(color: .black.opacity(0.25), radius: 4, y: 2)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(task.title)
                                .font(.title3.weight(.bold))
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)

                            Text(task.category.title)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.secondary)

                            HStack(spacing: 6) {
                                Image(systemName: "ladybug.fill")
                                    .foregroundStyle(AppColors.gold)
                                Text("+\(task.importance.flyCoinReward)")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(AppColors.gold)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    )

                    AppTextField(
                        title: "Comment",
                        placeholder: "What did you accomplish?",
                        text: $comment
                    )
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Jump Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Complete", action: onComplete)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.neonGreen)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    JumpTaskSheetView(
        task: LilyPadTaskItem(
            title: "Finish SwiftUI course module",
            category: .hardSkills,
            deadline: Date(),
            importance: .high
        ),
        comment: .constant(""),
        onComplete: {},
        onCancel: {}
    )
}
