import SwiftUI

struct WeeklyJumpChart: View {
    let values: [Int]
    private let labels = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        let maxValue = max(values.max() ?? 1, 1)

        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly Jumps")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(AppColors.neonGreen)
                            .frame(height: CGFloat(value) / CGFloat(maxValue) * (screenHeight * 0.12))

                        Text(labels[index])
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: screenHeight * 0.16)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
}

#Preview {
    WeeklyJumpChart(values: [2, 3, 1, 4, 2, 1, 1])
        .padding()
}
