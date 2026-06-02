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
}
