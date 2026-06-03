import SwiftUI

struct FrogPodiumView: View {
    let stage: FrogEvolutionStage
    let progress: Double
    let nextStageTitle: String?

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.neonGreen.opacity(0.35),
                                Color.black.opacity(0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: screenWidth * 0.72, height: screenHeight * 0.055)
                    .offset(y: screenHeight * 0.11)

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.podiumFillTop,
                                AppColors.podiumFillBottom
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.25), lineWidth: 2)
                    )
                    .frame(width: screenWidth * 0.58, height: screenHeight * 0.1)
                    .offset(y: screenHeight * 0.075)

                Image(stage.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: screenHeight * 0.2)
                    .shadow(color: .black.opacity(0.35), radius: 10, y: 6)
            }
            .frame(height: screenHeight * 0.24)

            VStack(spacing: 8) {
                Text(stage.title)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .riverTextShadow()

                Text("Level \(stage.level)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.gold)
                    .riverTextShadow()

                if let nextStageTitle {
                    VStack(spacing: 6) {
                        ProgressView(value: progress)
                            .tint(AppColors.neonGreen)

                        Text("Next: \(nextStageTitle)")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.85))
                            .riverTextShadow()
                    }
                    .padding(.horizontal, 28)
                } else {
                    Text("Max evolution reached")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppColors.neonGreen)
                        .riverTextShadow()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
