import SwiftUI

struct RiverFrogHomePadView: View {
    var showsFrog: Bool = true

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("lily")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: RiverElementLayoutConfig.lilyPadBaseWidth)

            if showsFrog {
                Image("frog1_5")
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
