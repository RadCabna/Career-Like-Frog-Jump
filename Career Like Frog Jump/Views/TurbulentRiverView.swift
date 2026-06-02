import SwiftUI

struct TurbulentRiverView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        Group {
            if store.hasGlobalGoal {
                RiverGameSceneView()
            } else {
                TurbulentRiverEmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tabScreenBackground(.river)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MainTabView()
        .environmentObject(CareerPathStore.previewWithGoalAndTasks)
}
