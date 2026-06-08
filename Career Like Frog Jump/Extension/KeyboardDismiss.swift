import SwiftUI
import UIKit

enum KeyboardDismiss {
    private static weak var keyWindow: UIWindow?
    private static var tapRecognizer: UITapGestureRecognizer?

    static func endEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    /// Call once at launch. Dismisses keyboard on background taps without blocking buttons.
    static func installGlobalTapToDismissIfNeeded() {
        guard tapRecognizer == nil else { return }
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap(\.windows)
            .first(where: \.isKeyWindow) else { return }

        let tap = UITapGestureRecognizer(target: TapTarget.shared, action: #selector(TapTarget.dismiss))
        tap.cancelsTouchesInView = false
        tap.delegate = TapTarget.shared
        window.addGestureRecognizer(tap)
        keyWindow = window
        tapRecognizer = tap
    }

    private final class TapTarget: NSObject, UIGestureRecognizerDelegate {
        static let shared = TapTarget()

        @objc func dismiss() {
            KeyboardDismiss.endEditing()
        }

        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            true
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            guard let view = touch.view else { return true }
            if view is UIControl { return false }
            if view.closestSuperview(of: UIControl.self) != nil { return false }
            return true
        }
    }
}

private extension UIView {
    func closestSuperview<T: UIView>(of type: T.Type) -> T? {
        var current: UIView? = self
        while let view = current {
            if let match = view as? T { return match }
            current = view.superview
        }
        return nil
    }
}

extension View {
    /// No-op marker — global installer handles dismissal. Safe on screens with buttons.
    func dismissKeyboardOnTapOutside() -> some View {
        self
    }
}
