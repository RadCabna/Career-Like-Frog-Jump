import SwiftUI

struct RiverAddTaskButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(AppColors.neonGreen)
                    .frame(width: RiverElementLayoutConfig.addButtonSize, height: RiverElementLayoutConfig.addButtonSize)
                    .shadow(color: .black.opacity(0.35), radius: 6, y: 3)

                Image(systemName: "plus")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add task")
    }
}

#Preview {
    RiverAddTaskButton(action: {})
}
