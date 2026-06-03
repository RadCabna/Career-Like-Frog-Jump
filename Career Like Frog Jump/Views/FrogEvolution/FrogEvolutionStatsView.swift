import SwiftUI

struct FrogEvolutionStatsView: View {
    let jumpsCompleted: Int
    let threatsDefeated: Int
    let experiencePoints: Int

    var body: some View {
        HStack(spacing: 12) {
            FrogEvolutionStatCard(
                icon: "arrow.up.circle.fill",
                title: "Jumps made",
                value: "\(jumpsCompleted)"
            )

            FrogEvolutionStatCard(
                icon: "shield.lefthalf.filled",
                title: "Threats beaten",
                value: "\(threatsDefeated)"
            )

            FrogEvolutionStatCard(
                icon: "sparkles",
                title: "XP",
                value: "\(experiencePoints)"
            )
        }
    }
}

private struct FrogEvolutionStatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(AppColors.neonGreen)
                .frame(width: 28, height: 28)

            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(minHeight: 34, alignment: .top)
        }
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .top)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }
}
