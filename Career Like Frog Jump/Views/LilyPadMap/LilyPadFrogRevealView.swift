import SwiftUI

struct LilyPadFrogRevealView: View {
    let revealProgress: CGFloat

    var body: some View {
        RiverFrogHomePadView()
            .offset(y: (1 - revealProgress) * screenHeight * 0.28)
            .opacity(revealProgress)
    }
}

#Preview {
    LilyPadFrogRevealView(revealProgress: 1)
}
