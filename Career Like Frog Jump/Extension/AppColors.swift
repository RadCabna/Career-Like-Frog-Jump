import SwiftUI

enum AppColors {
    static let neonGreen = Color(red: 50 / 255, green: 205 / 255, blue: 50 / 255)
    static let threatOrange = Color(red: 1, green: 69 / 255, blue: 0)
    static let gold = Color(red: 1, green: 215 / 255, blue: 0)
    static let placeholder = Color(red: 0.55, green: 0.55, blue: 0.58)
    static let primaryLabel = Color(red: 0, green: 0, blue: 0)
    static let secondaryLabel = Color(red: 60 / 255, green: 60 / 255, blue: 67 / 255)
    /// Light-theme text field fill — same in light and dark mode.
    static let textFieldFill = Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
    /// Light-theme sheet / grouped screen background.
    static let lightGroupedBackground = Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255)
    /// Frosted-glass panels over river/sky backgrounds — use `.fill(AppColors.frostedPanel)`.
    static let frostedPanel = Material.ultraThin
    static let podiumFillTop = Color(red: 235 / 255, green: 235 / 255, blue: 240 / 255)
    static let podiumFillBottom = Color(red: 220 / 255, green: 220 / 255, blue: 225 / 255)
    static let chartIdleRed = Color(red: 0.92, green: 0.22, blue: 0.22)
    static let chartProjectsBlue = Color(red: 0.35, green: 0.72, blue: 1)
}
