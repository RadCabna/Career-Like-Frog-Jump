import SwiftUI

struct CreateGlobalGoalView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Place Your Golden Goal")
                .font(.headline.weight(.semibold))
                .foregroundStyle(AppColors.gold)

            AppTextField(
                title: "Goal Name",
                placeholder: "Senior Dev, Startup, Relocation…",
                placeholderFont: .subheadline,
                text: Binding(
                    get: { store.goalCreationDraft },
                    set: { store.updateGoalDraft($0) }
                )
            )

            Button(action: store.saveGlobalGoal) {
                Text("Save Goal")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppColors.neonGreen, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
            .disabled(store.goalCreationDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
                .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
        )
    }
}

#Preview {
    CreateGlobalGoalView()
        .environmentObject(CareerPathStore())
        .padding()
}
