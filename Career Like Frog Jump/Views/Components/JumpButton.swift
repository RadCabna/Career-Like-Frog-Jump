import SwiftUI

struct JumpButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title3.weight(.semibold))
                Text("JUMP")
                    .font(.headline.weight(.bold))
                    .tracking(1.2)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(AppColors.neonGreen, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Jump")
        .accessibilityHint("Records a career step and moves your frog forward")
    }
}

#Preview {
    JumpButton {}
        .padding()
}
