import Foundation

enum FrogSkinID: String, CaseIterable, Identifiable, Codable {
    case classic
    case tie
    case diplomat
    case cyber

    var id: String { rawValue }
}

struct FrogSkinDefinition: Identifiable {
    let id: FrogSkinID
    let title: String
    let subtitle: String
    let price: Int
    let restingFrame: String
    let lifebuoyFrame: String
    let jumpFrames: [String]
    let shopPreviewFrame: String

    var isDefault: Bool {
        id == .classic
    }
}

enum FrogSkinCatalog {
    static let all: [FrogSkinDefinition] = [
        FrogSkinDefinition(
            id: .classic,
            title: "Classic Frog",
            subtitle: "Your default river look",
            price: 0,
            restingFrame: "frog1_1",
            lifebuoyFrame: "frog1_5",
            jumpFrames: ["frog1_2", "frog1_3", "frog1_4"],
            shopPreviewFrame: "frog1_1"
        ),
        FrogSkinDefinition(
            id: .tie,
            title: "Frog in a Tie",
            subtitle: "Boardroom ready amphibian",
            price: 80,
            restingFrame: "frog2_1",
            lifebuoyFrame: "frog2_5",
            jumpFrames: ["frog2_2", "frog2_3", "frog2_4"],
            shopPreviewFrame: "frog2_1"
        ),
        FrogSkinDefinition(
            id: .diplomat,
            title: "Diplomat Frog",
            subtitle: "Negotiates every deadline",
            price: 100,
            restingFrame: "frog3_1",
            lifebuoyFrame: "frog3_5",
            jumpFrames: ["frog3_2", "frog3_3", "frog3_4"],
            shopPreviewFrame: "frog3_1"
        ),
        FrogSkinDefinition(
            id: .cyber,
            title: "Cyber Frog",
            subtitle: "Augmented focus circuits",
            price: 120,
            restingFrame: "frog4_1",
            lifebuoyFrame: "frog4_5",
            jumpFrames: ["frog4_2", "frog4_3", "frog4_4"],
            shopPreviewFrame: "frog4_1"
        )
    ]

    static func skin(for id: FrogSkinID) -> FrogSkinDefinition {
        all.first { $0.id == id } ?? all[0]
    }
}
