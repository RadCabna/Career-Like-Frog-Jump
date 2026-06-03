import SwiftUI

struct MicroStepsShieldView: View {
    @ObservedObject var viewModel: ThreatRadarViewModel

    var body: some View {
        NavigationStack {
            Group {
                if let task = viewModel.microStepsTargetTask {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Current task")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(AppColors.secondaryLabel)
                                    .textCase(.uppercase)

                                Text(task.title)
                                    .font(.title3.weight(.bold))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(AppColors.textFieldFill)
                            )

                            Text("Add 5 micro-steps under this task. The eagle flies away when you save the plan.")
                                .font(.subheadline)
                                .foregroundStyle(AppColors.secondaryLabel)

                            ForEach(0..<ThreatRadarConfig.microStepCount, id: \.self) { index in
                                AppTextField(
                                    title: "Step \(index + 1)",
                                    placeholder: "Small actionable step",
                                    text: binding(for: index)
                                )
                            }

                            Button {
                                viewModel.submitMicroSteps()
                            } label: {
                                Text("Save Plan")
                                    .font(.headline.weight(.bold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(
                                        viewModel.microStepsIsValid ? AppColors.neonGreen : Color.gray.opacity(0.4),
                                        in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    )
                            }
                            .buttonStyle(.plain)
                            .disabled(!viewModel.microStepsIsValid)
                        }
                        .padding(20)
                    }
                } else {
                    ContentUnavailableView(
                        "No active task",
                        systemImage: "leaf",
                        description: Text("Add a task on Lily Pads before splitting it into micro-steps.")
                    )
                }
            }
            .background(AppColors.lightGroupedBackground)
            .navigationTitle("Micro-Step Plan")
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

    private func binding(for index: Int) -> Binding<String> {
        Binding(
            get: { viewModel.microStepEntries[index] },
            set: { viewModel.microStepEntries[index] = $0 }
        )
    }
}
