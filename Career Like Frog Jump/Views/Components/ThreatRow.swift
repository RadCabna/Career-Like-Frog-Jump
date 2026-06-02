import SwiftUI

struct ThreatRow: View {
    let threat: ThreatItem

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)
                .foregroundStyle(AppColors.threatOrange)

            VStack(alignment: .leading, spacing: 4) {
                Text(threat.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(threat.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        ThreatRow(threat: ThreatItem(title: "Burnout wave", detail: "Three late nights", severity: .high))
    }
}
