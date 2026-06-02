import Foundation

struct ThreatItem: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let severity: ThreatSeverity
}

enum ThreatSeverity {
    case high
    case medium
}

@MainActor
final class ThreatRadarViewModel: ObservableObject {
    @Published var threats: [ThreatItem] = [
        ThreatItem(title: "Burnout wave", detail: "Three late nights this week", severity: .high),
        ThreatItem(title: "Deadline crocodile", detail: "Certification form overdue", severity: .high),
        ThreatItem(title: "Procrastination drift", detail: "Portfolio task postponed twice", severity: .medium)
    ]

    @Published var shieldsAvailable = 2

    func activateAwarenessShield() {
        guard shieldsAvailable > 0, !threats.isEmpty else { return }
        shieldsAvailable -= 1
        threats.removeFirst()
    }
}
