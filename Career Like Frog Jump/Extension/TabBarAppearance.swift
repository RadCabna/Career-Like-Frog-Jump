import UIKit

enum TabBarAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.78)
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.45)

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

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = UIColor(red: 50 / 255, green: 205 / 255, blue: 50 / 255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
    }
}
