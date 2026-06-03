import SwiftUI

struct ThreatRadarView: View {
    @EnvironmentObject private var store: CareerPathStore
    @EnvironmentObject private var viewModel: ThreatRadarViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThreatRadarCircleView(
                    activeThreat: viewModel.activeThreat,
                    approachingThreatKind: viewModel.approachingThreatKind,
                    blinkingSectorIndex: viewModel.blinkingSectorIndex,
                    onSectorTap: viewModel.handleSectorTap
                )
                .frame(maxWidth: min(screenWidth * 0.88, screenHeight * 0.42))
                .padding(.top, 8)

                statusCard

                if store.isProgressFrozen || viewModel.isDayOffActiveOnRadar {
                    dayOffBanner
                }

                if store.hasConfidenceBuff {
                    confidenceBanner
                }

                if store.cognitiveLoadReduced {
                    cognitiveLoadBanner
                }

                if store.isBacklogCleanupActive {
                    backlogCleanupBanner
                }

                statsRow
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .scrollContentBackground(.hidden)
        .simultaneousGesture(TapGesture().onEnded { viewModel.recordInteraction() })
        .tabScreenBackground(AppBackgroundStore.kind(for: .threatRadar))
        .navigationTitle(AppTab.threatRadar.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onDisappear {
            viewModel.detachFromThreatTab()
        }
        .sheet(isPresented: $viewModel.isPresentingShieldPicker) {
            if let threat = viewModel.activeThreat {
                ThreatShieldPickerView(
                    threat: threat,
                    onSelect: viewModel.selectShield,
                    onCancel: { viewModel.isPresentingShieldPicker = false }
                )
            }
        }
        .fullScreenCover(item: $viewModel.selectedShield) { shield in
            shieldFlow(for: shield)
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let threat = viewModel.activeThreat {
                HStack(spacing: 10) {
                    DangerIconView(assetName: threat.dangerAssetName, size: screenHeight * 0.04)

                    Label("Threat on radar", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.threatOrange)
                }

                Text("Tap the blinking sector to activate a shield.")
                    .font(.footnote)
                    .foregroundStyle(AppColors.secondaryLabel)
            } else if viewModel.isThreatApproaching, let kind = viewModel.approachingThreatKind {
                HStack(spacing: 10) {
                    DangerIconView(assetName: kind.dangerAssetName, size: screenHeight * 0.04)

                    Label("Threat approaching", systemImage: "waveform.path")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppColors.threatOrange)
                }

                Text("Complete a jump on the river to move the frog and send it away.")
                    .font(.footnote)
                    .foregroundStyle(AppColors.secondaryLabel)
            } else {
                Label("Scanning the river", systemImage: "dot.radiowaves.left.and.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppColors.neonGreen)

                Text("If the frog does not move for 48 hours, the nearest threat will approach with a warning pulse.")
                    .font(.footnote)
                    .foregroundStyle(AppColors.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }

    private var backlogCleanupBanner: some View {
        HStack(spacing: 12) {
            DangerIconView(assetName: ThreatKind.chaosWhirlwind.dangerAssetName, size: screenHeight * 0.04)

            VStack(alignment: .leading, spacing: 4) {
                Text("Backlog cleanup in progress")
                    .font(.subheadline.weight(.bold))
                Text("Open Lily Pads and delete or delegate one task.")
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.threatOrange.opacity(0.12))
        )
    }

    private var dayOffBanner: some View {
        HStack(spacing: 12) {
            ShieldIconView(shield: .lifebuoyRest, size: screenHeight * 0.04)

            VStack(alignment: .leading, spacing: 4) {
                Text("Lifebuoy rest active")
                    .font(.subheadline.weight(.bold))
                Text("Progress is frozen for 24 hours. Streak stays safe.")
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.gold.opacity(0.12))
        )
    }

    private var confidenceBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title2)
                .foregroundStyle(AppColors.neonGreen)

            VStack(alignment: .leading, spacing: 4) {
                Text("Confidence buff active")
                    .font(.subheadline.weight(.bold))
                Text("Your wins stay with you for 24 hours.")
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.neonGreen.opacity(0.12))
        )
    }

    private var cognitiveLoadBanner: some View {
        HStack(spacing: 12) {
            DangerIconView(assetName: ThreatKind.chaosWhirlwind.dangerAssetName, size: screenHeight * 0.04)
                .opacity(0.7)

            VStack(alignment: .leading, spacing: 4) {
                Text("Cognitive load eased")
                    .font(.subheadline.weight(.bold))
                Text("Backlog trimmed — focus capacity +5%.")
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            ThreatStatBadge(title: "XP", value: "\(store.experiencePoints)", color: AppColors.gold)
            ThreatStatBadge(title: "Flies", value: "\(store.flyCoins)", color: AppColors.gold)
            ThreatStatBadge(
                title: "Hearts",
                value: "\(store.halfHearts / 2)",
                color: AppColors.threatOrange
            )
        }
    }

    @ViewBuilder
    private func shieldFlow(for shield: ThreatShieldType) -> some View {
        switch shield {
        case .focusTimer:
            PomodoroShieldView(viewModel: viewModel)
        case .confidenceDiary:
            ConfidenceDiaryShieldView(viewModel: viewModel)
        case .lifebuoyRest:
            DayOffShieldView(viewModel: viewModel)
        case .microSteps:
            MicroStepsShieldView(viewModel: viewModel)
        case .backlogCleanup:
            EmptyView()
        }
    }
}

private struct ThreatStatBadge: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(AppColors.secondaryLabel)
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.frostedPanel)
        )
    }
}

#Preview {
    NavigationStack {
        ThreatRadarView()
            .environmentObject(CareerPathStore.previewWithGoalAndTasks)
            .environmentObject(ThreatRadarViewModel())
    }
}
