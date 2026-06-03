import UIKit

enum AppAppearance {
    /// Forces light interface style for UIKit-backed controls (forms, sheets, pickers).
    static func configure() {
        UIView.appearance().overrideUserInterfaceStyle = .light
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UICollectionView.appearance().backgroundColor = .clear
        UIScrollView.appearance().backgroundColor = .clear
    }
}
