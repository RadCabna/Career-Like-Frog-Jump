import SwiftUI

struct BacklogCleanupBannerView: View {
    var body: some View {
        HStack(spacing: 12) {
            DangerIconView(assetName: ThreatKind.chaosWhirlwind.dangerAssetName, size: screenHeight * 0.045)

            VStack(alignment: .leading, spacing: 4) {
                Text("Chaos Whirlwind active")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .riverTextShadow()

                Text("Delete or delegate one task below to calm the whirlwind.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.9))
                    .riverTextShadow()
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.threatOrange.opacity(0.85))
        )
    }
}

#Preview {
    BacklogCleanupBannerView()
        .padding()
}
