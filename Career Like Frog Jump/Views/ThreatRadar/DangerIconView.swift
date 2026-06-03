import SwiftUI

struct DangerIconView: View {
    let assetName: String
    var size: CGFloat = AppScreenMetrics.height * 0.08

    var body: some View {
        Image(assetName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.45), radius: 4, y: 2)
    }
}

#Preview {
    HStack(spacing: 16) {
        ForEach(ThreatKind.allCases) { kind in
            DangerIconView(assetName: kind.dangerAssetName)
        }
    }
    .padding()
}
