import SwiftUI

struct RiverSceneHUDView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        GeometryReader { geometry in
            let insets = geometry.safeAreaInsets
            let horizontalPadding = RiverElementLayoutConfig.hudEdgePadding
            let verticalPadding = RiverElementLayoutConfig.hudVerticalPadding

            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    RiverHeartsView(halfHearts: store.halfHearts)

                    Spacer(minLength: 0)

                    RiverFlyCounterView(count: store.flyCoins)
                }

                Spacer(minLength: 0)

                HStack {
                    Spacer(minLength: 0)

                    RiverJumpButtonView(
                        isEnabled: !store.incompleteTasks.isEmpty && !store.isJumpAnimating,
                        action: store.presentJumpTask
                    )
                }
            }
//            .padding(.top, insets.top + verticalPadding)
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
