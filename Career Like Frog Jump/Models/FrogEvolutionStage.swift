import Foundation

struct FrogEvolutionStage: Identifiable, Equatable {
    let level: Int
    let requiredXP: Int
    let title: String
    let assetName: String

    var id: Int { level }
}

enum FrogEvolutionCatalog {
    static let stages: [FrogEvolutionStage] = [
        FrogEvolutionStage(level: 1, requiredXP: 0, title: "River Tadpole", assetName: "evoFrog_1"),
        FrogEvolutionStage(level: 2, requiredXP: 30, title: "Stream Hopper", assetName: "evoFrog_2"),
        FrogEvolutionStage(level: 3, requiredXP: 100, title: "Career Frog", assetName: "evoFrog_3"),
        FrogEvolutionStage(level: 4, requiredXP: 250, title: "Senior Leaper", assetName: "evoFrog_4"),
        FrogEvolutionStage(level: 5, requiredXP: 500, title: "Golden Amphibian", assetName: "evoFrog_5")
    ]

    static func stage(forXP xp: Int) -> FrogEvolutionStage {
        stages.last { xp >= $0.requiredXP } ?? stages[0]
    }

    static func nextStage(after stage: FrogEvolutionStage) -> FrogEvolutionStage? {
        stages.first { $0.level == stage.level + 1 }
    }

    static func progressToNextStage(xp: Int, current: FrogEvolutionStage) -> Double {
        guard let next = nextStage(after: current) else { return 1 }
        let span = next.requiredXP - current.requiredXP
        guard span > 0 else { return 1 }
        let gained = xp - current.requiredXP
        return min(max(Double(gained) / Double(span), 0), 1)
    }
}

struct LevelUpPresentation: Identifiable, Equatable {
    let fromStage: FrogEvolutionStage
    let toStage: FrogEvolutionStage

    var id: Int { toStage.level }
}
