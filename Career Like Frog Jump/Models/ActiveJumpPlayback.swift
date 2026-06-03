import Foundation

struct ActiveJumpPlayback: Equatable {
    let animation: RiverJumpAnimation
    let flightFrameNames: [String]
    let restingPadFrameName: String
    let homeRestingFrameName: String
    let inPlace: Bool
    let startedAt: Date
}
