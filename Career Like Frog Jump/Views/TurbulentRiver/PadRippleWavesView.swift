import SwiftUI

struct PadRippleWavesView: View {
    enum Style {
        case threat
        case lifebuoy

        var color: Color {
            switch self {
            case .threat: AppColors.threatOrange
            case .lifebuoy: AppColors.neonGreen
            }
        }
    }

    let style: Style

    private let ringCount = 4
    private let cycleDuration = 2.2
    private var baseDiameter: CGFloat {
        RiverElementLayoutConfig.lilyPadBaseWidth * 0.5
    }

    private var maxDiameter: CGFloat {
        RiverElementLayoutConfig.lilyPadBaseWidth * 1.75
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSinceReferenceDate

            ZStack {
                ForEach(0..<ringCount, id: \.self) { index in
                    let phase = (elapsed / cycleDuration + Double(index) / Double(ringCount))
                        .truncatingRemainder(dividingBy: 1)
                    let diameter = baseDiameter + (maxDiameter - baseDiameter) * phase
                    let opacity = (1 - phase) * 0.8

                    Circle()
                        .stroke(style.color.opacity(opacity * 0.35), lineWidth: 8)
                        .blur(radius: 2)
                        .frame(width: diameter, height: diameter)

                    Circle()
                        .stroke(style.color.opacity(opacity), lineWidth: 2.5)
                        .frame(width: diameter, height: diameter)
                }
            }
        }
        .frame(width: maxDiameter * 1.15, height: maxDiameter * 1.15)
        .allowsHitTesting(false)
    }
}

#Preview("Threat") {
    ZStack {
        Color.black.opacity(0.3)
        PadRippleWavesView(style: .threat)
    }
}

#Preview("Lifebuoy") {
    ZStack {
        Color.black.opacity(0.3)
        PadRippleWavesView(style: .lifebuoy)
    }
}
