import Foundation

struct PlaceLilyPadDraft: Equatable {
    static let titleCharacterLimit = 40

    var title: String = ""
    var category: LilyPadCategory = .hardSkills
    var deadline: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    var importance: LilyPadImportance = .medium

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValid: Bool {
        !trimmedTitle.isEmpty && trimmedTitle.count <= Self.titleCharacterLimit
    }
}
