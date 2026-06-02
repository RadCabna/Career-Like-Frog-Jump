import SwiftUI

struct RiverJumpingFrogView: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: RiverElementLayoutConfig.frogWidth)
            .id(imageName)
    }
}

#Preview {
    RiverJumpingFrogView(imageName: "frog1_3")
}
