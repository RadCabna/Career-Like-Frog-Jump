import Foundation

enum ThreatKind: String, CaseIterable, Identifiable, Codable {
    case deadlineCrocodile
    case doubtSnake
    case burnoutBat
    case micromanagementEagle
    case chaosWhirlwind

    var id: String { rawValue }

    var title: String {
        switch self {
        case .deadlineCrocodile: "Deadline Crocodile"
        case .doubtSnake: "Doubt Snake"
        case .burnoutBat: "Burnout Bat"
        case .micromanagementEagle: "Micromanagement Eagle"
        case .chaosWhirlwind: "Chaos Whirlwind"
        }
    }

    var metaphor: String {
        switch self {
        case .deadlineCrocodile: "Task pile-up, burning deadlines"
        case .doubtSnake: "Imposter syndrome, fear of judgment"
        case .burnoutBat: "Lost energy, apathy, routine"
        case .micromanagementEagle: "Pressure, no autonomy"
        case .chaosWhirlwind: "Multitasking, lost focus"
        }
    }

    var detail: String { metaphor }

    var dangerAssetName: String {
        switch self {
        case .deadlineCrocodile: "dangerCrocodile"
        case .doubtSnake: "dangerSnake"
        case .burnoutBat: "dangerBat"
        case .micromanagementEagle: "dangerEagle"
        case .chaosWhirlwind: "dangerTornado"
        }
    }

    var sectorIndex: Int {
        switch self {
        case .deadlineCrocodile: 0
        case .doubtSnake: 1
        case .burnoutBat: 3
        case .micromanagementEagle: 5
        case .chaosWhirlwind: 7
        }
    }

    var recommendedShield: ThreatShieldType {
        switch self {
        case .deadlineCrocodile: .focusTimer
        case .doubtSnake: .confidenceDiary
        case .burnoutBat: .lifebuoyRest
        case .micromanagementEagle: .microSteps
        case .chaosWhirlwind: .backlogCleanup
        }
    }

    var defeatXP: Int {
        switch self {
        case .deadlineCrocodile: 10
        case .micromanagementEagle: 15
        default: 0
        }
    }

    var restoresThreatHealthOnDefeat: Bool {
        switch self {
        case .burnoutBat: false
        default: true
        }
    }

    var grantsConfidenceBuff: Bool {
        self == .doubtSnake
    }

    var grantsCognitiveLoadRelief: Bool {
        self == .chaosWhirlwind
    }

    var pomodoroUsesBreakPhase: Bool {
        false
    }

    var pomodoroWorkSeconds: Int {
        switch self {
        case .deadlineCrocodile: 2 * 60 * 60
        default: ThreatRadarConfig.standardPomodoroWorkSeconds
        }
    }

    var victoryMessage: String {
        switch self {
        case .deadlineCrocodile: "The crocodile swam away. The river is calm."
        case .doubtSnake: "The snake dissolved. Confidence buff active for 24h."
        case .burnoutBat: "The bat flew off. Progress is frozen and your streak is safe."
        case .micromanagementEagle: "The eagle flew away. Your 5-step plan is saved."
        case .chaosWhirlwind: "The whirlwind settled. Cognitive load eased."
        }
    }
}

struct RiverThreat: Identifiable, Equatable, Codable {
    let id: UUID
    let kind: ThreatKind
    let appearedAt: Date

    init(id: UUID = UUID(), kind: ThreatKind, appearedAt: Date = Date()) {
        self.id = id
        self.kind = kind
        self.appearedAt = appearedAt
    }

    var title: String { kind.title }
    var detail: String { kind.detail }
    var sectorIndex: Int { kind.sectorIndex }
    var dangerAssetName: String { kind.dangerAssetName }
}

enum ThreatRadarConfig {
    static let sectorCount = 8
    /// Frog must not move (complete a jump) for this long before a threat approaches.
    static let frogInactivityThreshold: TimeInterval = 48 * 60 * 60
    /// Pulsing warning on the river / radar before the threat fully arrives.
    static let threatApproachWarningDuration: TimeInterval = 2 * 60 * 60
    /// Minimum time after defeating a threat before another can approach.
    static let threatRespawnCooldownAfterDefeat: TimeInterval = 24 * 60 * 60
    static let frogInactivityCheckInterval: TimeInterval = 60
    static let threatHeartPenalty = 1
    static let threatHeartRestore = 1
    static let standardPomodoroWorkSeconds = 25 * 60
    static let standardPomodoroBreakSeconds = 5 * 60
    static let confidenceEntryCount = 3
    static let microStepCount = 5
    static let dayOffDuration: TimeInterval = 24 * 60 * 60
    static let confidenceBuffDuration: TimeInterval = 24 * 60 * 60

}
