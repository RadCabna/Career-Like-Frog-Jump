import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var store: CareerPathStore

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
        .tabBarIconShadow()
        .onAppear {
            TabBarIconShadowRefresher.post()
        }
        .onChange(of: store.selectedTab) { _, _ in
            TabBarIconShadowRefresher.post()
        }
    }

    @ViewBuilder
    private func tabContent<Content: View>(_ tab: AppTab, @ViewBuilder content: () -> Content) -> some View {
        NavigationStack {
            content()
        }
        .tabItem {
            Label(tab.tabBarTitle, systemImage: tab.systemImage)
        }
        .tag(tab)
    }
}

#Preview {
    MainTabView()
        .environmentObject(CareerPathStore())
}
