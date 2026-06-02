import SwiftUI

struct RiverSceneBackgroundView: View {
    var body: some View {
        ZStack {
            Image("riverBG")
                .resizable()
                .scaledToFill()
                .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
                .clipped()
                .ignoresSafeArea()

            HStack(spacing: 0) {
                bankEdgeImage("leftBankRiverBG")
                Spacer(minLength: 0)
            }
            .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
            .ignoresSafeArea()
            .offset(x: -screenHeight*0.04)

            HStack(spacing: 0) {
                Spacer(minLength: 0)
                bankEdgeImage("rightBankRiverBG")
            }
            .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
            .ignoresSafeArea()
            .offset(x: screenHeight*0.04)
        }
        .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    private func bankEdgeImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: AppScreenMetrics.height)
    }
}

#Preview {
    RiverSceneBackgroundView()
}
