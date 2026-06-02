import SwiftUI

struct RiverHeartsView: View {
    let halfHearts: Int

    var body: some View {
        HStack(spacing: RiverElementLayoutConfig.heartSpacing) {
            ForEach(0..<FrogHeartDisplay.heartCount, id: \.self) { index in
                RiverHeartView(
                    visual: FrogHeartDisplay.visual(forSlot: index, halfHearts: halfHearts),
                    pulseIndex: index
                )
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Lives")
        .accessibilityValue("\(halfHearts / 2) hearts")
    }
}

private struct RiverHeartView: View {
    let visual: FrogHeartVisual
    let pulseIndex: Int

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate
            let scale = heartPulseScale(elapsed: elapsed, index: pulseIndex)

            Image(visual.assetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: RiverElementLayoutConfig.heartSize)
                .scaleEffect(scale)
        }
    }

    private func heartPulseScale(elapsed: TimeInterval, index: Int) -> CGFloat {
        let cycleDuration = 3.0
        let stagger = 1.0
        let pulseDuration = 0.35
        let growDuration = 0.18
        let local = elapsed - Double(index) * stagger
        let phase = local - floor(local / cycleDuration) * cycleDuration

        guard phase >= 0, phase < pulseDuration else { return 1 }

        if phase < growDuration {
            return 1 + CGFloat(phase / growDuration) * 0.12
        }

        let shrinkProgress = (phase - growDuration) / (pulseDuration - growDuration)
        return 1.12 - CGFloat(shrinkProgress) * 0.12
    }
}

#Preview {
    ZStack {
        Color.blue
        RiverHeartsView(halfHearts: 5)
    }
}
