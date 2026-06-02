import SwiftUI

extension View {
    func tabScreenBackground(_ kind: AppBackgroundKind) -> some View {
        background {
            AppTabBackgroundView(kind: kind)
                .transaction { transaction in
                    transaction.animation = nil
                }
        }
    }
}
