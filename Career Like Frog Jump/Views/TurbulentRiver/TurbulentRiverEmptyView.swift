import SwiftUI

struct TurbulentRiverEmptyView: View {
    @EnvironmentObject private var store: CareerPathStore

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Jump to your goal. Dodge obstacles. Don't drown in routine.")
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .riverTextShadow()
                .padding(.horizontal, 36)

            Button(action: store.requestGoalCreation) {
                Text("Create Goal")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .riverTextShadow()
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColors.neonGreen, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: .black.opacity(0.45), radius: 8, y: 4)
            }
            .padding(.horizontal, 48)

            Spacer()
            Spacer()
        }
        .safeAreaPadding(.horizontal, 16)
        .safeAreaPadding(.bottom, 16)
    }
}

#Preview {
    TurbulentRiverEmptyView()
        .environmentObject(CareerPathStore())
        .tabScreenBackground(.river)
}
