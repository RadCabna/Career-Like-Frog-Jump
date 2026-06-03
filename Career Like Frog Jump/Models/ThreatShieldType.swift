import Foundation

enum ThreatShieldType: String, CaseIterable, Identifiable {
    case focusTimer
    case confidenceDiary
    case lifebuoyRest
    case microSteps
    case backlogCleanup

    var id: String { rawValue }

    var title: String {
        switch self {
        case .focusTimer: "Pomodoro Timer"
        case .confidenceDiary: "Confidence Diary"
        case .lifebuoyRest: "Lifebuoy Rest"
        case .microSteps: "5 Micro-Steps"
        case .backlogCleanup: "Backlog Cleanup"
        }
    }

    var assetName: String {
        switch self {
        case .focusTimer: "shieldTime"
        case .confidenceDiary: "shieldBook"
        case .lifebuoyRest: "shieldLifebuoy"
        case .microSteps: "shieldTime"
        case .backlogCleanup: "shieldBook"
        }
    }

    func subtitle(for threat: ThreatKind) -> String {
        switch (self, threat) {
        case (.focusTimer, .deadlineCrocodile):
            return "Built-in 2-hour focus timer. Finish it to repel the crocodile."
        case (.focusTimer, _):
            return "Focus timer to repel the threat."
        case (.confidenceDiary, .doubtSnake):
            return "Write 3 achievements. The Doubt Snake dissolves."
        case (.confidenceDiary, _):
            return "Three wins or strengths to dissolve the threat."
        case (.lifebuoyRest, .burnoutBat):
            return "Freeze progress for 24 hours. Streak stays safe."
        case (.lifebuoyRest, _):
            return "24-hour pause on the lifebuoy."
        case (.microSteps, .micromanagementEagle):
            return "Split the current task into 5 micro-steps."
        case (.microSteps, _):
            return "Break work into 5 small checklist items."
        case (.backlogCleanup, .chaosWhirlwind):
            return "Go to Lily Pads and delete or delegate one task."
        case (.backlogCleanup, _):
            return "Remove or delegate one backlog task."
        }
    }
}
