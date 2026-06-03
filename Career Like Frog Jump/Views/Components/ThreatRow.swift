import SwiftUI

struct ThreatRow: View {
    let threat: RiverThreat

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            DangerIconView(assetName: threat.dangerAssetName, size: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(threat.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(AppColors.primaryLabel)

                Text(threat.detail)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.secondaryLabel)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ThreatRow(threat: RiverThreat(kind: .burnoutBat))
    }
}
