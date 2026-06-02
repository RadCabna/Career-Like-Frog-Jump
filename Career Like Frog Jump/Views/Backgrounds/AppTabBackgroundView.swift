import SwiftUI

struct AppTabBackgroundView: View {
    let kind: AppBackgroundKind

    var body: some View {
        Group {
            switch kind {
            case .river:
                RiverSceneBackgroundView()
            case .sky(let bottomImageName):
                SkyHorizonBackgroundView(bottomImageName: bottomImageName)
            }
        }
        .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}

#Preview("River") {
    AppTabBackgroundView(kind: .river)
}

#Preview("Sky") {
    AppTabBackgroundView(kind: .sky(bottomImageName: "cityBG"))
}
