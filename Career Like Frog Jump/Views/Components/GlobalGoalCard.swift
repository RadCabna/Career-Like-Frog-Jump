import SwiftUI

struct GlobalGoalCard: View {
    let title: String
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Global Goal", systemImage: "star.circle.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.gold)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppColors.gold)
            }

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)
                .riverTextShadow()

            ProgressView(value: progress)
                .tint(AppColors.gold)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(AppColors.gold.opacity(0.35), lineWidth: 1)
        )
    }
}

#Preview {
    GlobalGoalCard(title: "Senior Product Designer", progress: 0.42)
        .padding()
}
