import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case turbulentRiver
    case lilyPadMap
    case threatRadar
    case frogEvolution
    case jumpStatistics

    var id: String { rawValue }

    var title: String {
        switch self {
        case .turbulentRiver: "Turbulent River"
        case .lilyPadMap: "Lily Pad Map"
        case .threatRadar: "Threat Radar"
        case .frogEvolution: "Frog Evolution"
        case .jumpStatistics: "Jump Analytics"
        }
    }

    var tabBarTitle: String {
        switch self {
        case .turbulentRiver: "River"
        case .lilyPadMap: "Lily Pads"
        case .threatRadar: "Threats"
        case .frogEvolution: "Evolution"
        case .jumpStatistics: "Stats"
        }
    }

    var systemImage: String {
        switch self {
        case .turbulentRiver: "water.waves"
        case .lilyPadMap: "leaf.fill"
        case .threatRadar: "dot.radiowaves.left.and.right"
        case .frogEvolution: "trophy.fill"
        case .jumpStatistics: "chart.line.uptrend.xyaxis"
        }
    }
}
