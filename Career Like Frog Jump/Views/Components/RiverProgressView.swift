import SwiftUI

struct RiverProgressView: View {
    let completedPads: Int
    let totalPads: Int

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("🐸")
                    .font(.title)
                Spacer()
                Text("\(completedPads)/\(totalPads) lily pads")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(AppColors.secondaryLabel)
            }

            HStack(spacing: 8) {
                ForEach(0..<totalPads, id: \.self) { index in
                    Image(systemName: index < completedPads ? "leaf.fill" : "leaf")
                        .font(.caption)
                        .foregroundStyle(index < completedPads ? AppColors.neonGreen : Color.secondary.opacity(0.35))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.textFieldFill)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("River progress")
        .accessibilityValue("\(completedPads) of \(totalPads) lily pads secured")
    }
}

#Preview {
    RiverProgressView(completedPads: 7, totalPads: 12)
        .padding()
}
