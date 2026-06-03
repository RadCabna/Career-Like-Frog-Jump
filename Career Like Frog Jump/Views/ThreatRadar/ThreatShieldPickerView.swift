import SwiftUI

struct ThreatShieldPickerView: View {
    let threat: RiverThreat
    let onSelect: (ThreatShieldType) -> Void
    let onCancel: () -> Void

    private var sheetHeight: CGFloat {
        screenHeight * 0.72
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 16) {
                        DangerIconView(assetName: threat.dangerAssetName, size: screenHeight * 0.1)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Incoming Threat")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AppColors.secondaryLabel)
                                .textCase(.uppercase)

                            Text(threat.title)
                                .font(.title3.weight(.bold))

                            Text(threat.detail)
                                .font(.subheadline)
                                .foregroundStyle(AppColors.secondaryLabel)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppColors.textFieldFill)
                    )

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommended Shield")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppColors.secondaryLabel)
                            .textCase(.uppercase)

                        Button {
                            onSelect(threat.kind.recommendedShield)
                        } label: {
                            ThreatShieldOptionRow(
                                shield: threat.kind.recommendedShield,
                                threat: threat.kind
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .background(AppColors.lightGroupedBackground)
            .navigationTitle("Awareness Shield")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
            }
        }
        .presentationDetents([.height(sheetHeight), .large])
        .presentationDragIndicator(.visible)
    }
}

private struct ThreatShieldOptionRow: View {
    let shield: ThreatShieldType
    let threat: ThreatKind

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ShieldIconView(shield: shield, size: screenHeight * 0.056)

            VStack(alignment: .leading, spacing: 6) {
                Text(shield.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppColors.primaryLabel)

                Text(shield.subtitle(for: threat))
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryLabel)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.textFieldFill)
        )
    }
}

#Preview {
    ThreatShieldPickerView(
        threat: RiverThreat(kind: .chaosWhirlwind),
        onSelect: { _ in },
        onCancel: {}
    )
}
