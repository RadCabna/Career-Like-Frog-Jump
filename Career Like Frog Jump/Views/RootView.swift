import SwiftUI

struct RootView: View {
    @StateObject private var careerPathStore = CareerPathStore()

    var body: some View {
        MainTabView()
            .environmentObject(careerPathStore)
    }
}

#Preview {
    RootView()
}
