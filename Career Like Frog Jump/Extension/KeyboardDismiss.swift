import SwiftUI
import UIKit

enum KeyboardDismiss {
    static func endEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension View {
    /// Dismisses the keyboard when tapping outside focused fields.
    /// Do not attach to `TabView` — it blocks tab bar taps.
    func dismissKeyboardOnTapOutside() -> some View {
        simultaneousGesture(
            TapGesture().onEnded {
                KeyboardDismiss.endEditing()
            }
        )
    }
}
