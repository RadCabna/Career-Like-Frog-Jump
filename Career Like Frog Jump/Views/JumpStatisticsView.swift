import SwiftUI

struct JumpStatisticsView: View {
    @EnvironmentObject private var store: CareerPathStore
    @StateObject private var viewModel = JumpStatisticsViewModel()
    @State private var selectedCompletedGoal: CompletedGoalRecord?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                WeeklyJumpPaceChartView(weeks: viewModel.weeklyJumpWeeks)

                CategorySupportChartView(slices: viewModel.categorySlices)

                VStack(spacing: 0) {
                    ForEach(viewModel.stats) { stat in
                        HStack {
                            Text(stat.label)
                                .foregroundStyle(AppColors.secondaryLabel)
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
                        .fill(AppColors.frostedPanel)
                )

                completedGoalsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, screenHeight * 0.02)
            .padding(.bottom, 12)
        }
        .scrollContentBackground(.hidden)
        .tabScreenBackground(AppBackgroundStore.kind(for: .jumpStatistics))
        .navigationTitle("Jump Analytics")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onAppear {
            viewModel.refresh(from: store)
        }
        .onChange(of: store.jumpsCompleted) { _, _ in
            viewModel.refresh(from: store)
        }
        .onChange(of: store.tasks) { _, _ in
            viewModel.refresh(from: store)
        }
        .onChange(of: store.completedGoals) { _, _ in
            viewModel.refresh(from: store)
        }
        .fullScreenCover(item: $selectedCompletedGoal) { goal in
            GoalProgressReviewView(
                goalTitle: goal.title,
                tasks: goal.tasks,
                primaryButtonTitle: "Close",
                onPrimary: { selectedCompletedGoal = nil }
            )
            .interactiveDismissDisabled()
        }
    }

    @ViewBuilder
    private var completedGoalsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completed Goals")
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .riverTextShadow()

            if store.completedGoals.isEmpty {
                Text("Finished career paths will appear here.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                    .riverTextShadow()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 0) {
                    ForEach(store.completedGoals) { goal in
                        Button {
                            selectedCompletedGoal = goal
                        } label: {
                            HStack(alignment: .top, spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(goal.title)
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(AppColors.primaryLabel)
                                        .multilineTextAlignment(.leading)

                                    Text(goal.completedAt, format: .dateTime.month(.abbreviated).day().year())
                                        .font(.caption)
                                        .foregroundStyle(AppColors.secondaryLabel)

                                    Text(goal.progressSummary)
                                        .font(.caption2)
                                        .foregroundStyle(AppColors.neonGreen)
                                }

                                Spacer(minLength: 0)

                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(AppColors.secondaryLabel)
                            }
                            .padding(.vertical, 14)
                        }
                        .buttonStyle(.plain)

                        if goal.id != store.completedGoals.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.frostedPanel)
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        JumpStatisticsView()
            .environmentObject(CareerPathStore.previewWithGoalAndTasks)
    }
}
