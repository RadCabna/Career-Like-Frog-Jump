import SwiftUI

struct GoalAchievedOverlayView: View {
    let presentation: GoalAchievedPresentation
    let onSetNewGoal: () -> Void
    let onViewProgress: () -> Void

    @State private var titleScale: CGFloat = 0.7
    @State private var contentOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.75)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Text("Goal Achieved!")
                    .font(.system(size: screenHeight * 0.038, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppColors.gold)
                    .scaleEffect(titleScale)
                    .shadow(color: AppColors.gold.opacity(0.55), radius: 10)

                Image(presentation.frogAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: screenHeight * 0.16)
                    .opacity(contentOpacity)

                VStack(spacing: 10) {
                    Text("You completed every lily pad on your path.")
                        .font(.body.weight(.medium))
                        .foregroundStyle(.white.opacity(0.92))
                        .multilineTextAlignment(.center)

                    Text(presentation.completedGoalTitle)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppColors.neonGreen)
                        .multilineTextAlignment(.center)
                }
                .opacity(contentOpacity)

                VStack(spacing: 12) {
                    Button(action: onViewProgress) {
                        Text("View Progress")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(AppColors.neonGreen, lineWidth: 2)
                            )
                    }

                    Button(action: onSetNewGoal) {
                        Text("Set a New Goal")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppColors.neonGreen, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                .padding(.top, 8)
                .opacity(contentOpacity)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.78)) {
                titleScale = 1
                contentOpacity = 1
            }
        }
    }
}
