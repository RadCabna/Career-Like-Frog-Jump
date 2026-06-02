import SwiftUI

struct JumpStatisticsView: View {
    @StateObject private var viewModel = JumpStatisticsViewModel()

    var body: some View {
        ScrollView {
                VStack(spacing: 20) {
                    WeeklyJumpChart(values: viewModel.weeklyJumpCounts)

                    VStack(spacing: 0) {
                        ForEach(viewModel.stats) { stat in
                            HStack {
                                Text(stat.label)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(stat.value)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(AppColors.neonGreen)
                            }
                            .padding(.vertical, 14)

                            if stat.id != viewModel.stats.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, screenHeight * 0.02)
                .padding(.bottom, 12)
            }
        .scrollContentBackground(.hidden)
        .tabScreenBackground(AppBackgroundStore.kind(for: .jumpStatistics))
        .navigationTitle(AppTab.jumpStatistics.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        JumpStatisticsView()
    }
}
