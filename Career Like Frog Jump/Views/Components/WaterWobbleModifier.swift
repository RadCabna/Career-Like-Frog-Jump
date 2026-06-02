import SwiftUI

struct WaterWobbleModifier: ViewModifier {
    let index: Int
    var amplitude: CGFloat
    var rotationAmplitude: Double
    var duration: TimeInterval = RiverElementLayoutConfig.wobbleDuration

    func body(content: Content) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate
            let phase = elapsed * (2 * Double.pi / duration)
            let seed = Double(index) * 0.9
            let verticalOffset = amplitude * CGFloat(sin(phase + seed))
            let rotation = rotationAmplitude * sin(phase * 0.85 + seed)

            content
                .offset(y: verticalOffset)
                .rotationEffect(.degrees(rotation))
        }
    }
}

extension View {
    func waterWobble(
        index: Int,
        amplitude: CGFloat = RiverElementLayoutConfig.frogWobbleAmplitude,
        rotationAmplitude: Double = RiverElementLayoutConfig.wobbleRotationAmplitude
    ) -> some View {
        modifier(WaterWobbleModifier(
            index: index,
            amplitude: amplitude,
            rotationAmplitude: rotationAmplitude
        ))
    }
}

extension View {
    func riverTextShadow() -> some View {
        shadow(color: .black.opacity(0.72), radius: 4, x: 0, y: 2)
    }
}
