import SwiftUI

struct FloatingLilyPadTaskView: View {
    let task: LilyPadTaskItem
    let driftOffset: CGFloat

    private var padSize: CGFloat {
        screenWidth * 0.14 * task.importance.padScale
    }

    var body: some View {
        HStack(spacing: 14) {
            Image(task.category.riverAssetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: padSize)
                .shadow(color: .black.opacity(0.45), radius: 2, y: 1)

            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(task.isOverdue ? AppColors.threatOrange : .white)
                    .shadow(color: .black.opacity(0.65), radius: 2, y: 1)
                    .strikethrough(task.isCompleted, color: .white.opacity(0.7))
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(task.category.title)
                        .font(.caption.weight(.medium))
                    Text("•")
                    Text(task.deadline, format: .dateTime.month(.abbreviated).day().hour().minute())
                        .font(.caption)
                }
                .foregroundStyle(.white.opacity(0.88))
                .shadow(color: .black.opacity(0.55), radius: 2, y: 1)

                if !task.progressReviewStatusLabels.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(task.progressReviewStatusLabels, id: \.self) { statusLabel in
                            Text(statusLabel)
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(statusLabelColor(for: statusLabel))
                                .shadow(color: .black.opacity(0.5), radius: 2, y: 1)
                        }
                    }
                }

                if task.isOverdue {
                    Text("Overdue")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(AppColors.threatOrange)
                        .shadow(color: .black.opacity(0.5), radius: 2, y: 1)
                }
            }

            Spacer(minLength: 0)

            VStack(spacing: 4) {
                Image(systemName: "ladybug.fill")
                    .foregroundStyle(AppColors.gold)
                    .shadow(color: .black.opacity(0.5), radius: 2, y: 1)
                Text("+\(task.importance.flyCoinReward)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(AppColors.gold)
                    .shadow(color: .black.opacity(0.5), radius: 2, y: 1)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.frostedPanel)
                .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
        )
        .offset(y: driftOffset)
        .opacity(task.isDeleted ? 0.72 : 1)
    }

    private func statusLabelColor(for statusLabel: String) -> Color {
        switch statusLabel {
        case "Deleted": .secondary
        case "Delegated": AppColors.gold
        case "Completed": AppColors.neonGreen
        default: .white.opacity(0.88)
        }
    }

}

#Preview {
    ZStack {
        Color.blue
        FloatingLilyPadTaskView(
            task: LilyPadTaskItem(
                title: "Finish SwiftUI course module",
                category: .hardSkills,
                deadline: Date(),
                importance: .high
            ),
            driftOffset: 0
        )
        .padding()
    }
}
