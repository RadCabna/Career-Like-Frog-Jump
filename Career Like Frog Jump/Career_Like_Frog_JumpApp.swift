import SwiftUI

@main
struct Career_Like_Frog_JumpApp: App {
    init() {
        TabBarAppearance.configure()
        ScrollableContentAppearance.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
