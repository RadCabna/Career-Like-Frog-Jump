import SwiftUI

struct RiverGoldenGoalView: View {
    let title: String

    var body: some View {
        VStack(spacing: 4) {
            Text("Your Golden Goal")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(AppColors.gold.opacity(0.95))
                .riverTextShadow()

            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .riverTextShadow()
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Your Golden Goal")
        .accessibilityValue(title)
    }
}

#Preview {
    ZStack {
        Color.blue
        RiverGoldenGoalView(title: "Senior Developer")
            .padding(.horizontal, 20)
    }
}
