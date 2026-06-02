import Foundation
import CoreGraphics

struct RiverJumpAnimation: Equatable, Identifiable {
    let id = UUID()
    let fromSlotIndex: Int
    let toSlotIndex: Int
}

enum RiverJumpPhase {
    case preDelay
    case flying
    case landingHold
}

enum FrogJumpSprite {
    static let frameSequence = ["frog1_1", "frog1_2", "frog1_3", "frog1_4", "frog1_1"]

    static func frameName(for progress: CGFloat) -> String {
        let clamped = max(0, min(progress, 1))
        let index = min(Int(clamped * 4.999), frameSequence.count - 1)
        return frameSequence[index]
    }
}

enum RiverJumpArc {
    static func point(progress: CGFloat, from: CGPoint, to: CGPoint, arcHeight: CGFloat) -> CGPoint {
        let t = max(0, min(progress, 1))
        let control = CGPoint(
            x: (from.x + to.x) * 0.5,
            y: (from.y + to.y) * 0.5 - arcHeight
        )
        let inverse = 1 - t

        return CGPoint(
            x: inverse * inverse * from.x + 2 * inverse * t * control.x + t * t * to.x,
            y: inverse * inverse * from.y + 2 * inverse * t * control.y + t * t * to.y
        )
    }

    static func arcHeight(from: CGPoint, to: CGPoint) -> CGFloat {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let distance = hypot(dx, dy)
        return max(AppScreenMetrics.height * 0.09, distance * 0.42)
    }
}

enum RiverJumpTimeline {
    static func phase(elapsed: TimeInterval) -> RiverJumpPhase {
        let preDelay = RiverElementLayoutConfig.jumpPreDelay
        let flightEnd = preDelay + RiverElementLayoutConfig.jumpDuration

        if elapsed < preDelay {
            return .preDelay
        }
        if elapsed < flightEnd {
            return .flying
        }
        if RiverElementLayoutConfig.jumpLandingHold > 0 {
            return .landingHold
        }
        return .flying
    }

    static func flightProgress(elapsed: TimeInterval) -> CGFloat {
        let preDelay = RiverElementLayoutConfig.jumpPreDelay
        let duration = RiverElementLayoutConfig.jumpDuration
        guard elapsed >= preDelay, duration > 0 else { return 0 }

        return CGFloat(min(max((elapsed - preDelay) / duration, 0), 1))
    }

    static var isComplete: (TimeInterval) -> Bool {
        { elapsed in elapsed >= RiverElementLayoutConfig.jumpTotalDuration }
    }
}
