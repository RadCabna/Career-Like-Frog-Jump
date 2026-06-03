import SwiftUI

struct ThreatRadarSectorShape: Shape {
    let sectorIndex: Int
    let sectorCount: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let sweep = 360.0 / Double(sectorCount)
        let start = Angle(degrees: Double(sectorIndex) * sweep - 90)
        let end = Angle(degrees: Double(sectorIndex + 1) * sweep - 90)

        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}
