import SwiftUI

struct ThreatRadarCircleView: View {
    let activeThreat: RiverThreat?
    let approachingThreatKind: ThreatKind?
    let blinkingSectorIndex: Int?
    let onSectorTap: (Int) -> Void

    private var isThreatApproaching: Bool {
        approachingThreatKind != nil && activeThreat == nil
    }

    private let sectorCount = ThreatRadarConfig.sectorCount

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = size / 2

            ZStack {
                ForEach(0..<sectorCount, id: \.self) { index in
                    ThreatRadarSectorView(
                        sectorIndex: index,
                        sectorCount: sectorCount,
                        isThreatSector: blinkingSectorIndex == index,
                        isThreatHighlighted: blinkingSectorIndex == index
                            && (activeThreat != nil || isThreatApproaching)
                    )
                    .contentShape(ThreatRadarSectorShape(sectorIndex: index, sectorCount: sectorCount))
                    .onTapGesture {
                        onSectorTap(index)
                    }
                }

                if let threat = activeThreat {
                    threatSectorIcon(
                        assetName: threat.dangerAssetName,
                        sectorIndex: threat.sectorIndex,
                        size: size * 0.2,
                        radius: radius,
                        center: center
                    )
                } else if let kind = approachingThreatKind {
                    threatSectorIcon(
                        assetName: kind.dangerAssetName,
                        sectorIndex: kind.sectorIndex,
                        size: size * 0.16,
                        radius: radius,
                        center: center,
                        opacity: 0.75
                    )
                }

                Circle()
                    .strokeBorder(Color.white.opacity(0.35), lineWidth: 2)

                Circle()
                    .strokeBorder(AppColors.neonGreen.opacity(0.5), lineWidth: 1)
                    .padding(size * 0.12)

                radarCenter(size: size, activeThreat: activeThreat, approachingKind: approachingThreatKind)
            }
            .frame(width: size, height: size)
            .position(x: center.x, y: center.y)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    @ViewBuilder
    private func threatSectorIcon(
        assetName: String,
        sectorIndex: Int,
        size: CGFloat,
        radius: CGFloat,
        center: CGPoint,
        opacity: Double = 1
    ) -> some View {
        DangerIconView(assetName: assetName, size: size)
            .opacity(opacity)
            .position(
                ThreatRadarLayout.sectorIconPoint(
                    sectorIndex: sectorIndex,
                    sectorCount: sectorCount,
                    radius: radius,
                    center: center
                )
            )
            .allowsHitTesting(false)
    }

    @ViewBuilder
    private func radarCenter(size: CGFloat, activeThreat: RiverThreat?, approachingKind: ThreatKind?) -> some View {
        VStack(spacing: 6) {
            if let threat = activeThreat {
                DangerIconView(assetName: threat.dangerAssetName, size: size * 0.14)

                Text(threat.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .riverTextShadow()
                    .lineLimit(2)
                    .frame(maxWidth: size * 0.42)
            } else if let kind = approachingKind {
                DangerIconView(assetName: kind.dangerAssetName, size: size * 0.12)

                Text("Threat approaching")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppColors.threatOrange)
                    .multilineTextAlignment(.center)
                    .riverTextShadow()
                    .lineLimit(2)
                    .frame(maxWidth: size * 0.42)
            } else {
                Image(systemName: "checkmark.shield.fill")
                    .font(.system(size: size * 0.1))
                    .foregroundStyle(AppColors.neonGreen)
                    .shadow(color: .black.opacity(0.4), radius: 4, y: 2)

                Text("River calm")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .riverTextShadow()
            }
        }
    }
}

enum ThreatRadarLayout {
    static func sectorIconPoint(
        sectorIndex: Int,
        sectorCount: Int,
        radius: CGFloat,
        center: CGPoint
    ) -> CGPoint {
        let sweep = 360.0 / Double(sectorCount)
        let midAngleDegrees = (Double(sectorIndex) + 0.5) * sweep - 90
        let radians = midAngleDegrees * .pi / 180
        let iconRadius = radius * 0.62

        return CGPoint(
            x: center.x + CGFloat(cos(radians)) * iconRadius,
            y: center.y + CGFloat(sin(radians)) * iconRadius
        )
    }
}

private struct ThreatRadarSectorView: View {
    let sectorIndex: Int
    let sectorCount: Int
    let isThreatSector: Bool
    let isThreatHighlighted: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            ThreatRadarSectorShape(sectorIndex: sectorIndex, sectorCount: sectorCount)
                .fill(sectorColor(elapsed: timeline.date.timeIntervalSinceReferenceDate))
        }
    }

    private func sectorColor(elapsed: TimeInterval) -> Color {
        guard isThreatSector, isThreatHighlighted else {
            return AppColors.neonGreen.opacity(0.12)
        }

        let pulse = 0.45 + 0.35 * sin(elapsed * 4)
        return AppColors.threatOrange.opacity(pulse)
    }
}

#Preview {
    ZStack {
        Color.black
        ThreatRadarCircleView(
            activeThreat: RiverThreat(kind: .doubtSnake),
            approachingThreatKind: nil,
            blinkingSectorIndex: 1,
            onSectorTap: { _ in }
        )
        .padding(40)
    }
}
