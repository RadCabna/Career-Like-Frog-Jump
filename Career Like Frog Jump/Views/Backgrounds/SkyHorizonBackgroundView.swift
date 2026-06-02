import SwiftUI

struct SkyHorizonBackgroundView: View {
    let bottomImageName: String

    var body: some View {
        ZStack {
            Image("skyBG")
                .resizable()
                .scaledToFill()
                .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 0)
                Image(bottomImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: AppScreenMetrics.width)
            }
            .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
            .ignoresSafeArea()
        }
        .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    SkyHorizonBackgroundView(bottomImageName: "forestBG")
}
