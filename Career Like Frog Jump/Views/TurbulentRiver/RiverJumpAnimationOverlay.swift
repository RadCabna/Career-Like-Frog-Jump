import SwiftUI

struct RiverJumpAnimationOverlay: View {
    let playback: ActiveJumpPlayback
    let elapsed: TimeInterval
    let layout: RiverSceneLayout

    var body: some View {
        let jump = playback.animation
        let phase = RiverJumpTimeline.phase(elapsed: elapsed)

        Group {
            switch phase {
            case .preDelay:
                RiverJumpingFrogView(imageName: padFrameName(for: jump.fromSlotIndex, playback: playback))
                    .position(layout.frogPoint(forSlotIndex: jump.fromSlotIndex))

            case .flying:
                let progress = RiverJumpTimeline.flightProgress(elapsed: elapsed)
                let flightElapsed = RiverJumpTimeline.elapsedInFlight(elapsed: elapsed)
                RiverJumpingFrogView(
                    imageName: FrogJumpSprite.frameName(
                        elapsedInFlight: flightElapsed,
                        flightFrames: playback.flightFrameNames
                    )
                )
                .position(jumpingFrogPoint(progress: progress, jump: jump, inPlace: playback.inPlace))

            case .landingHold:
                if RiverElementLayoutConfig.jumpLandingHold > 0 {
                    RiverJumpingFrogView(imageName: playback.restingPadFrameName)
                        .position(layout.frogPoint(forSlotIndex: jump.toSlotIndex))
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func jumpingFrogPoint(progress: CGFloat, jump: RiverJumpAnimation, inPlace: Bool) -> CGPoint {
        let from = layout.frogPoint(forSlotIndex: jump.fromSlotIndex)
        let to = layout.frogPoint(forSlotIndex: jump.toSlotIndex)
        let arcHeight: CGFloat
        if inPlace {
            arcHeight = AppScreenMetrics.height * 0.06
        } else {
            arcHeight = RiverJumpArc.arcHeight(from: from, to: to)
        }

        return RiverJumpArc.point(
            progress: progress,
            from: from,
            to: to,
            arcHeight: arcHeight
        )
    }

    private func padFrameName(for slotIndex: Int, playback: ActiveJumpPlayback) -> String {
        if slotIndex < 0 {
            return playback.homeRestingFrameName
        }
        return playback.restingPadFrameName
    }
}
