import SwiftUI

struct LevelUpOverlayView: View {
    let presentation: LevelUpPresentation
    let onDismiss: () -> Void

    @State private var revealProgress: CGFloat = 0
    @State private var titleScale: CGFloat = 0.6
    @State private var titleOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.72)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Level Up!")
                    .font(.system(size: screenHeight * 0.04, weight: .heavy, design: .rounded))
                    .foregroundStyle(AppColors.gold)
                    .scaleEffect(titleScale)
                    .opacity(titleOpacity)
                    .shadow(color: AppColors.gold.opacity(0.6), radius: 12)

                ZStack {
                    Image(presentation.fromStage.assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: screenHeight * 0.14)
                        .opacity(1 - revealProgress)
                        .scaleEffect(1 - revealProgress * 0.2)

                    Image(presentation.toStage.assetName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: screenHeight * 0.2)
                        .opacity(revealProgress)
                        .scaleEffect(0.85 + revealProgress * 0.15)
                }

                VStack(spacing: 8) {
                    Text(presentation.toStage.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)

                    Text("Evolution level \(presentation.toStage.level)")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.neonGreen)
                }
            }
            .padding(32)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.45)) {
                revealProgress = 1
                titleScale = 1
                titleOpacity = 1
            }

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(2.2))
                onDismiss()
            }
        }
    }
}
