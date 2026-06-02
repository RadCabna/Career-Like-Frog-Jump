import Foundation

enum TabBarIconShadowRefresher {
    static let notification = Notification.Name("TabBarIconShadowRefresher.refresh")

    static func post() {
        NotificationCenter.default.post(name: notification, object: nil)
    }
}
