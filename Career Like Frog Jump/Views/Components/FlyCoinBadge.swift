import SwiftUI

struct FlyCoinBadge: View {
    let amount: Int

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "ladybug.fill")
                .foregroundStyle(AppColors.gold)
            Text("\(amount)")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppColors.gold)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(AppColors.gold.opacity(0.15))
        )
        .accessibilityLabel("Fly coins")
        .accessibilityValue("\(amount)")
    }
}

#Preview {
    FlyCoinBadge(amount: 1280)
}
