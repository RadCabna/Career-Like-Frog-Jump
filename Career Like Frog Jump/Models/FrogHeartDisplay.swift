import Foundation

enum FrogHeartVisual: String {
    case full
    case half
    case empty

    var assetName: String {
        switch self {
        case .full: "heartFull"
        case .half: "heartHalf"
        case .empty: "heartEmpty"
        }
    }
}

enum FrogHeartDisplay {
    static let maxHalfHearts = 6
    static let heartCount = 3

    static func visual(forSlot index: Int, halfHearts: Int) -> FrogHeartVisual {
        let clamped = max(0, min(halfHearts, maxHalfHearts))
        let remaining = clamped - index * 2

        if remaining >= 2 { return .full }
        if remaining == 1 { return .half }
        return .empty
    }
}
