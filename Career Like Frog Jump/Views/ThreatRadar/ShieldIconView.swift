import SwiftUI

struct ShieldIconView: View {
    let shield: ThreatShieldType
    var size: CGFloat = AppScreenMetrics.height * 0.052

    var body: some View {
        Image(shield.assetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 20) {
        ForEach(ThreatShieldType.allCases) { shield in
            ShieldIconView(shield: shield)
        }
    }
    .padding()
}
