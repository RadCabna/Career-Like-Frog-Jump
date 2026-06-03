import UIKit

enum TabBarAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .black
        appearance.backgroundEffect = nil
        appearance.shadowColor = .clear

        let titleShadow = NSShadow()
        titleShadow.shadowColor = UIColor.black
        titleShadow.shadowBlurRadius = 4
        titleShadow.shadowOffset = CGSize(width: 0, height: 1)

        let stacked = appearance.stackedLayoutAppearance
        stacked.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .shadow: titleShadow
        ]
        stacked.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 50 / 255, green: 205 / 255, blue: 50 / 255, alpha: 1),
            .shadow: titleShadow
        ]
        stacked.normal.iconColor = UIColor.white
        stacked.selected.iconColor = UIColor(red: 50 / 255, green: 205 / 255, blue: 50 / 255, alpha: 1)

        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = true
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = UIColor(red: 50 / 255, green: 205 / 255, blue: 50 / 255, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor.white
    }
}
