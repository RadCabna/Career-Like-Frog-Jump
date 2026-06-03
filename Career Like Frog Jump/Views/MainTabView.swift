import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var store: CareerPathStore
    @EnvironmentObject private var threatRadarViewModel: ThreatRadarViewModel

    var body: some View {
        TabView(selection: $store.selectedTab) {
            tabContent(.turbulentRiver) {
                TurbulentRiverView()
            }

            tabContent(.lilyPadMap) {
                LilyPadMapView()
            }

            tabContent(.threatRadar) {
                ThreatRadarView()
            }

            tabContent(.frogEvolution) {
                FrogEvolutionView()
            }

            tabContent(.jumpStatistics) {
                JumpStatisticsView()
            }
        }
        .tint(AppColors.neonGreen)
        .toolbarBackground(Color.black, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarColorScheme(.dark, for: .tabBar)
        .tabBarIconShadow()
        .onAppear {
            TabBarIconShadowRefresher.post()
            threatRadarViewModel.attach(store: store)
        }
        .onChange(of: store.selectedTab) { _, _ in
            TabBarIconShadowRefresher.post()
        }
        .overlay {
            if let presentation = store.levelUpPresentation {
                LevelUpOverlayView(presentation: presentation) {
                    store.dismissLevelUpPresentation()
                }
                .transition(.opacity)
                .zIndex(20)
            }
        }
        .overlay {
            if let presentation = store.goalAchievedPresentation {
                GoalAchievedOverlayView(
                    presentation: presentation,
                    onSetNewGoal: store.beginNewGoalAfterAchievement,
                    onViewProgress: store.presentCelebrationProgressReview
                )
                .transition(.opacity)
                .zIndex(25)
            }
        }
        .fullScreenCover(isPresented: $store.isPresentingCelebrationProgressReview) {
            if let goalTitle = store.globalGoalTitle, store.hasGlobalGoal {
                GoalProgressReviewView(
                    goalTitle: goalTitle,
                    tasks: store.goalProgressReviewTasks,
                    primaryButtonTitle: "New Goal",
                    onPrimary: store.beginNewGoalAfterAchievement
                )
                .interactiveDismissDisabled()
            }
        }
        .animation(.easeInOut(duration: 0.25), value: store.levelUpPresentation != nil)
        .animation(.easeInOut(duration: 0.25), value: store.goalAchievedPresentation != nil)
        .alert("Threat Defeated", isPresented: $threatRadarViewModel.isPresentingVictory) {
            Button("Continue", role: .cancel) {
                threatRadarViewModel.victoryMessage = nil
                threatRadarViewModel.victoryRewardDetail = nil
            }
        } message: {
            Text(threatVictoryMessage)
        }
    }

    private var threatVictoryMessage: String {
        var parts: [String] = []
        if let message = threatRadarViewModel.victoryMessage {
            parts.append(message)
        }
        if let rewards = threatRadarViewModel.victoryRewardDetail {
            parts.append(rewards)
        }
        return parts.joined(separator: "\n\n")
    }

    @ViewBuilder
    private func tabContent<Content: View>(_ tab: AppTab, @ViewBuilder content: () -> Content) -> some View {
        NavigationStack {
            content()
        }
        .ignoresSafeArea(edges: .bottom)
        .tabItem {
            Label(tab.tabBarTitle, systemImage: tab.systemImage)
        }
        .tag(tab)
    }
}

#Preview {
    MainTabView()
        .environmentObject(CareerPathStore())
        .environmentObject(ThreatRadarViewModel())
}
