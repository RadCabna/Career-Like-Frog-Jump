import SwiftUI

struct PomodoroShieldView: View {
    @ObservedObject var viewModel: ThreatRadarViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                if let threat = viewModel.activeThreat {
                    DangerIconView(assetName: threat.dangerAssetName, size: screenHeight * 0.08)
                }

                VStack(spacing: 8) {
                    Text(phaseTitle)
                        .font(.title2.weight(.bold))

                    Text(pomodoroSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.secondaryLabel)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }

                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 10)

                    Circle()
                        .trim(from: 0, to: viewModel.pomodoroProgress)
                        .stroke(
                            viewModel.pomodoroPhase == .work ? AppColors.neonGreen : AppColors.gold,
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    Text(formattedTime(viewModel.pomodoroSecondsRemaining))
                        .font(.system(size: screenHeight * 0.04, weight: .bold, design: .rounded))
                        .monospacedDigit()
                }
                .frame(width: screenHeight * 0.22, height: screenHeight * 0.22)

                Button {
                    viewModel.togglePomodoro()
                } label: {
                    Text(viewModel.isPomodoroRunning ? "Pause" : "Start")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(AppColors.neonGreen, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)

                Text(footerHint)
                    .font(.footnote)
                    .foregroundStyle(AppColors.secondaryLabel)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.lightGroupedBackground)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        viewModel.dismissShieldFlow()
                    }
                }
            }
        }
    }

    private var phaseTitle: String {
        if viewModel.pomodoroPhase == .work {
            return isCrocodileThreat ? "2-Hour Focus" : "Focus Sprint"
        }
        return "Short Rest"
    }

    private var navigationTitle: String {
        isCrocodileThreat ? "Deadline Focus" : "Pomodoro Shield"
    }

    private var isCrocodileThreat: Bool {
        viewModel.activeThreat?.kind == .deadlineCrocodile
    }

    private var footerHint: String {
        if isCrocodileThreat {
            return "Finish the 2-hour timer to repel the crocodile. Health and +10 XP restored on completion."
        }
        return "Finish the focus block to repel the threat and restore health."
    }

    private var pomodoroSubtitle: String {
        if isCrocodileThreat {
            return "Built-in 2-hour focus timer"
        }
        return viewModel.pomodoroPhase == .work ? "25 minutes of deep work" : "5 minutes to breathe"
    }

    private func formattedTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainder = seconds % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, remainder)
        }
        return String(format: "%02d:%02d", minutes, remainder)
    }
}
