import Foundation

enum LilyPadCategory: String, CaseIterable, Identifiable, Codable {
    case hardSkills
    case networking
    case projects

    var id: String { rawValue }

    var title: String {
        switch self {
        case .hardSkills: "Hard Skills"
        case .networking: "Networking"
        case .projects: "Projects"
        }
    }

    var supportMetaphor: String {
        switch self {
        case .hardSkills: "Solid Lily Pad"
        case .networking: "Floating Log"
        case .projects: "Turtle"
        }
    }

    var subtitle: String {
        switch self {
        case .hardSkills: "Course, book, test"
        case .networking: "Conference, expert email, mentor session"
        case .projects: "Work task, portfolio update, GitHub commit"
        }
    }

    /// Compact label for Support Category picker (fits one line with checkmark).
    var pickerTitleLine: String {
        switch self {
        case .hardSkills: "Hard Skills (Lily)"
        case .networking: "Networking (Log)"
        case .projects: "Projects (Turtle)"
        }
    }

    var pickerSubtitleLine: String {
        switch self {
        case .hardSkills: "Course, book, test"
        case .networking: "Conference, mentor, email"
        case .projects: "Portfolio, task, commit"
        }
    }

    var systemImage: String {
        switch self {
        case .hardSkills: "book.fill"
        case .networking: "person.2.fill"
        case .projects: "briefcase.fill"
        }
    }

    var riverAssetName: String {
        switch self {
        case .hardSkills: "lily"
        case .networking: "log"
        case .projects: "tortle"
        }
    }

    /// Threat sector closest to the frog’s current lily pad focus.
    var nearestThreatKind: ThreatKind {
        switch self {
        case .hardSkills: .deadlineCrocodile
        case .networking: .doubtSnake
        case .projects: .micromanagementEagle
        }
    }
}
