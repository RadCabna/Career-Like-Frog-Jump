import SwiftUI

struct RiverFrogHomePadView: View {
    var showsFrog: Bool = true
    var frogAssetName: String = "frog1_1"

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("lily")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: RiverElementLayoutConfig.lilyPadBaseWidth)

            if showsFrog {
                Image(frogAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: RiverElementLayoutConfig.frogWidth)
            }
        }
        .waterWobble(
            index: 0,
            amplitude: RiverElementLayoutConfig.frogWobbleAmplitude
        )
    }
}

#Preview {
    RiverFrogHomePadView()
}
