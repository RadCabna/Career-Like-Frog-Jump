import SwiftUI

struct RiverSceneHUDView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding = RiverElementLayoutConfig.hudEdgePadding
            let verticalPadding = RiverElementLayoutConfig.hudVerticalPadding

            VStack(spacing: 8) {
                HStack(alignment: .top) {
                    RiverHeartsView(halfHearts: store.halfHearts)

                    Spacer(minLength: 0)

                    RiverFlyCounterView(count: store.flyCoins)
                }

                if let goalTitle = store.globalGoalTitle, store.hasGlobalGoal {
                    RiverGoldenGoalView(title: goalTitle)
                }

                Spacer(minLength: 0)

                HStack {
                    Spacer(minLength: 0)

                    RiverJumpButtonView(
                        isEnabled: (store.jumpTargetTask != nil || store.canCelebrateGoalAchievement) && !store.isJumpAnimating,
                        celebrationPulse: store.canCelebrateGoalAchievement,
                        action: store.handleJumpButtonTap
                    )
                }
            }
            .padding(.bottom, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .allowsHitTesting(true)
    }
}

#Preview {
    MainTabView()
        .environmentObject(CareerPathStore.previewWithGoalAndTasks)
}
