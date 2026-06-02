import SwiftUI

struct RiverFlyCounterView: View {
    let count: Int

    var body: some View {
        ZStack {
            Image("flyCounterFrame")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: RiverElementLayoutConfig.flyCounterWidth)

            Text("\(count)")
                .font(.system(size: screenHeight * 0.018, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.55), radius: 2, y: 1)
                .offset(x: screenHeight*0.02, y: screenHeight * 0.001)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Fly coins")
        .accessibilityValue("\(count)")
    }
}

#Preview {
    ZStack {
        Color.blue
        RiverFlyCounterView(count: 42)
    }
}
