import Foundation

@MainActor
final class FrogEvolutionViewModel: ObservableObject {
    @Published var frogName = "River Jumper"
    @Published var rankTitle = "Leapfrog Specialist"
    @Published var rankLevel = 4
    @Published var flyCoins = 1280
    @Published var awarenessShieldsEarned = 6
}
