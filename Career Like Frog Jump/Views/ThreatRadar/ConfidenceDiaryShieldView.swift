import SwiftUI

struct ConfidenceDiaryShieldView: View {
    @ObservedObject var viewModel: ThreatRadarViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Name 3 achievements or strengths. The Doubt Snake dissolves and your health is restored.")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.secondaryLabel)

                    ForEach(0..<ThreatRadarConfig.confidenceEntryCount, id: \.self) { index in
                        AppTextField(
                            title: "Entry \(index + 1)",
                            placeholder: "What went well?",
                            text: binding(for: index)
                        )
                    }

                    Button {
                        viewModel.submitConfidenceDiary()
                    } label: {
                        Text("Dissolve the Threat")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                viewModel.confidenceDiaryIsValid ? AppColors.neonGreen : Color.gray.opacity(0.4),
                                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
                            )
                    }
                    .buttonStyle(.plain)
                    .disabled(!viewModel.confidenceDiaryIsValid)
                }
                .padding(20)
            }
            .background(AppColors.lightGroupedBackground)
            .navigationTitle("Confidence Diary")
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
            get: { viewModel.confidenceEntries[index] },
            set: { viewModel.confidenceEntries[index] = $0 }
        )
    }
}
