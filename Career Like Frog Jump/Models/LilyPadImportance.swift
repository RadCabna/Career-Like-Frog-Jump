import Foundation
import CoreGraphics

enum LilyPadImportance: String, CaseIterable, Identifiable, Codable {
    case low
    case medium
    case high

    var id: String { rawValue }

    var title: String {
        switch self {
        case .low: "Low"
        case .medium: "Medium"
        case .high: "High"
        }
    }

    var padScale: CGFloat {
        switch self {
        case .low: 0.82
        case .medium: 1.0
        case .high: 1.18
        }
    }

    var flyCoinReward: Int {
        switch self {
        case .low: 5
        case .medium: 10
        case .high: 20
        }
    }
}
