import SwiftUI

struct FrogEvolutionView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                FrogPodiumView(
                    stage: store.evolutionStage,
                    progress: store.evolutionProgress,
                    nextStageTitle: store.nextEvolutionStage?.title
                )

                FrogEvolutionStatsView(
                    jumpsCompleted: store.jumpsCompleted,
                    threatsDefeated: store.threatsDefeated,
                    experiencePoints: store.experiencePoints
                )

                FrogSkinShopView()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 28)
        }
        .scrollContentBackground(.hidden)
        .tabScreenBackground(AppBackgroundStore.kind(for: .frogEvolution))
        .navigationTitle(AppTab.frogEvolution.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        FrogEvolutionView()
            .environmentObject(CareerPathStore.previewWithGoalAndTasks)
    }
}
