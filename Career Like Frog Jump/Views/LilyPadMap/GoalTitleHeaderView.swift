import SwiftUI

struct GoalTitleHeaderView: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Your Golden Goal")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppColors.gold.opacity(0.9))
                .riverTextShadow()

            Text(title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .riverTextShadow()
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }
}

#Preview {
    GoalTitleHeaderView(title: "Senior Developer")
        .padding()
        .tabScreenBackground(.river)
}
