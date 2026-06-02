import SwiftUI

struct FrogEvolutionView: View {
    @StateObject private var viewModel = FrogEvolutionViewModel()

    var body: some View {
        List {
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: "figure.mind.and.body")
                            .font(.system(size: screenHeight * 0.07))
                            .foregroundStyle(AppColors.neonGreen)
                            .frame(width: screenWidth * 0.18)

                        VStack(alignment: .leading, spacing: 6) {
                            Text(viewModel.frogName)
                                .font(.title2.weight(.bold))
                            Text(viewModel.rankTitle)
                                .font(.subheadline)
                                .foregroundStyle(AppColors.gold)
                        }
                    }
                    .padding(.vertical, 8)
                }

                Section("Rank") {
                    HStack {
                        Label("Level \(viewModel.rankLevel)", systemImage: "trophy.fill")
                            .foregroundStyle(AppColors.gold)
                        Spacer()
                        Text(viewModel.rankTitle)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Rewards") {
                    HStack {
                        Text("Fly Coins")
                        Spacer()
                        FlyCoinBadge(amount: viewModel.flyCoins)
                    }

                    NavigationLink {
                        ShopPlaceholderView()
                    } label: {
                        Label("Shop", systemImage: "bag.fill")
                            .foregroundStyle(AppColors.gold)
                    }
                }

                Section("Progress") {
                    LabeledContent("Awareness Shields Earned") {
                        Text("\(viewModel.awarenessShieldsEarned)")
                            .foregroundStyle(AppColors.neonGreen)
                            .fontWeight(.semibold)
                    }
                }
            }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .tabScreenBackground(AppBackgroundStore.kind(for: .frogEvolution))
        .navigationTitle(AppTab.frogEvolution.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

private struct ShopPlaceholderView: View {
    var body: some View {
        ContentUnavailableView(
            "Shop Coming Soon",
            systemImage: "bag.fill",
            description: Text("Spend fly coins on ranks and river upgrades.")
        )
        .foregroundStyle(AppColors.gold)
        .navigationTitle("Shop")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FrogEvolutionView()
    }
}
