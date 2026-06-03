import SwiftUI

struct RiverJumpButtonView: View {
    let isEnabled: Bool
    let celebrationPulse: Bool
    let action: () -> Void

    @State private var shadowPulse = false

    private var buttonSize: CGFloat {
        RiverElementLayoutConfig.riverJumpButtonSize * 1.5
    }

    var body: some View {
        Button(action: action) {
            Image("jumpButton")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: buttonSize)
                .modifier(JumpButtonShadowModifier(celebrationPulse: celebrationPulse, shadowPulse: shadowPulse))
                .opacity(isEnabled ? 1 : 0.45)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true)) {
                shadowPulse = true
            }
        }
        .accessibilityLabel(celebrationPulse ? "Celebrate goal" : "Jump")
        .accessibilityHint(accessibilityHint)
    }

    private var accessibilityHint: String {
        if celebrationPulse {
            return "Open goal achievement celebration"
        }
        return isEnabled ? "Open the next task to complete" : "No tasks left to jump to"
    }
}

private struct JumpButtonShadowModifier: ViewModifier {
    let celebrationPulse: Bool
    let shadowPulse: Bool

    func body(content: Content) -> some View {
        if celebrationPulse {
            content
                .shadow(
                    color: AppColors.gold.opacity(shadowPulse ? 0.95 : 0.4),
                    radius: shadowPulse ? 24 : 12,
                    y: 2
                )
                .shadow(
                    color: AppColors.neonGreen.opacity(shadowPulse ? 0.85 : 0.35),
                    radius: shadowPulse ? 18 : 8,
                    y: 0
                )
        } else {
            content
                .shadow(
                    color: AppColors.neonGreen.opacity(shadowPulse ? 0.9 : 0.35),
                    radius: shadowPulse ? 22 : 10,
                    y: 2
                )
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        RiverJumpButtonView(isEnabled: true, celebrationPulse: true, action: {})
    }
}
