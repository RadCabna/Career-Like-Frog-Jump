import SwiftUI

struct RiverJumpButtonView: View {
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("jumpButton")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: RiverElementLayoutConfig.riverJumpButtonSize)
                .opacity(isEnabled ? 1 : 0.45)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel("Jump")
        .accessibilityHint(isEnabled ? "Open the next task to complete" : "No tasks left to jump to")
    }
}

#Preview {
    ZStack {
        Color.blue
        RiverJumpButtonView(isEnabled: true, action: {})
    }
}
