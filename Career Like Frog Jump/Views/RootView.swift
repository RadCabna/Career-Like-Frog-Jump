import SwiftUI

struct RootView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var careerPathStore = CareerPathStore()
    @StateObject private var threatRadarViewModel = ThreatRadarViewModel()

    init() {
        AppAppearance.configure()
        TabBarAppearance.configure()
        ScrollableContentAppearance.configure()
    }

    var body: some View {
        MainTabView()
            .preferredColorScheme(.light)
            .environmentObject(careerPathStore)
            .environmentObject(threatRadarViewModel)
            .onAppear {
                KeyboardDismiss.installGlobalTapToDismissIfNeeded()
                threatRadarViewModel.attach(store: careerPathStore)
            }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    threatRadarViewModel.attach(store: careerPathStore)
                }
                guard phase == .background || phase == .inactive else { return }
                threatRadarViewModel.persistThreatStateToStore()
                careerPathStore.flushPersistence()
            }
    }
}

#Preview {
    RootView()
}
