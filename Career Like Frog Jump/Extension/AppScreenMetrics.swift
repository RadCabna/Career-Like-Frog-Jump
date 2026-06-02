import CoreGraphics
import UIKit

enum AppScreenMetrics {
    private static let bounds = UIScreen.main.bounds

    static let width: CGFloat = min(bounds.width, bounds.height)
    static let height: CGFloat = max(bounds.width, bounds.height)

    static var safeAreaTop: CGFloat {
        keyWindow?.safeAreaInsets.top ?? 0
    }

    static var safeAreaBottom: CGFloat {
        keyWindow?.safeAreaInsets.bottom ?? 0
    }

    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first { $0.isKeyWindow }
    }
}
