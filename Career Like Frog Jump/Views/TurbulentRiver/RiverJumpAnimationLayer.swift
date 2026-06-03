import SwiftUI

/// Drives jump frames via `TimelineView` and reports completion with a cancellable `.task(id:)`.
struct RiverJumpAnimationLayer: View {
    let playback: ActiveJumpPlayback
    let layout: RiverSceneLayout
    let onComplete: (UInt64) -> Void

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let elapsed = timeline.date.timeIntervalSince(playback.startedAt)
            RiverJumpAnimationOverlay(
                playback: playback,
                elapsed: elapsed,
                layout: layout
            )
        }
        .task(id: playback.animation.sequence) {
            try? await Task.sleep(for: .seconds(RiverElementLayoutConfig.jumpTotalDuration))
            onComplete(playback.animation.sequence)
        }
    }
}
