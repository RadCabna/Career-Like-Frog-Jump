import CoreGraphics
import Foundation

enum RiverElementLayoutConfig {
    static let showsAllLayoutSlots = false

    static var maxTaskCount: Int { taskOffsets.count }

    static var frogPadBottomMargin: CGFloat { screenHeight * 0.014 }

    static var topContentMargin: CGFloat { screenHeight * 0.0095 }

    static var frogPadOffset: CGPoint {
        CGPoint(x: -screenHeight * 0.04, y: -screenHeight * 0.02)
    }

    static var addButtonOffset: CGPoint {
        CGPoint(x: 0, y: -screenHeight * 0.109)
    }

    static var taskOffsets: [CGPoint] {
        [
            CGPoint(x: 0, y: -screenHeight * 0.072),
            CGPoint(x: screenHeight * 0.04, y: -screenHeight * 0.15),
            CGPoint(x: -screenHeight * 0.04, y: -screenHeight * 0.2),
            CGPoint(x: -screenHeight * 0.1, y: -screenHeight * 0.27),
            CGPoint(x: screenHeight * 0.02, y: -screenHeight * 0.33),
            CGPoint(x: screenHeight * 0.04, y: -screenHeight * 0.42),
            CGPoint(x: -screenHeight * 0.1, y: -screenHeight * 0.48),
            CGPoint(x: screenHeight * 0.0, y: -screenHeight * 0.56)
        ]
    }

    static var overflowStepOffset: CGPoint {
        CGPoint(x: 0, y: -screenHeight * 0.097)
    }

    static var lilyPadBaseWidth: CGFloat { screenHeight * 0.114 }

    static var logBaseWidth: CGFloat { screenHeight * 0.13 }

    static var tortleBaseWidth: CGFloat { screenHeight * 0.123 }

    static var frogWidth: CGFloat { screenHeight * 0.095 }

    static var sceneVerticalLift: CGFloat { frogWidth * 1.0 }

    static var addButtonSize: CGFloat { screenHeight * 0.052 }

    static var frogWobbleAmplitude: CGFloat { screenHeight * 0.009 }

    static var taskWobbleAmplitude: CGFloat { screenHeight * 0.007 }

    static var wobbleRotationAmplitude: Double { 4 }

    static var wobbleDuration: TimeInterval { 3.0 }

    static var heartSize: CGFloat { screenHeight * 0.028 }

    static var heartSpacing: CGFloat { screenHeight * 0.005 }

    static var flyCounterWidth: CGFloat { screenHeight * 0.115 }

    static var riverJumpButtonSize: CGFloat { screenHeight * 0.095 }

    static var hudEdgePadding: CGFloat { screenWidth * 0.045 }

    static var hudVerticalPadding: CGFloat { screenHeight * 0.012 }

    static var jumpPreDelay: TimeInterval { 0.5 }

    static var jumpDuration: TimeInterval { 0.9 }

    static var jumpLandingHold: TimeInterval { 0 }

    static var jumpTotalDuration: TimeInterval {
        jumpPreDelay + jumpDuration + jumpLandingHold
    }

    static var frogOnSupportYOffset: CGFloat { -screenHeight * 0.032 }

    static var frogHomeBodyYOffset: CGFloat { -screenHeight * 0.028 }

    static func slotOffset(for index: Int) -> CGPoint {
        index < 0 ? frogPadOffset : offsetForTask(at: index)
    }

    static func offsetForTask(at index: Int) -> CGPoint {
        guard index >= 0 else { return .zero }

        if index < taskOffsets.count {
            return taskOffsets[index]
        }

        let lastFixed = taskOffsets.last ?? overflowStepOffset
        let extraIndex = index - taskOffsets.count + 1
        return CGPoint(
            x: lastFixed.x + overflowStepOffset.x * CGFloat(extraIndex) * 0.35,
            y: lastFixed.y + overflowStepOffset.y * CGFloat(extraIndex)
        )
    }

    static func cumulativeOffsetForAddButton(taskCount: Int) -> CGPoint {
        var result = frogPadOffset
        for step in 0..<taskCount {
            result.x += offsetForTask(at: step).x
            result.y += offsetForTask(at: step).y
        }
        result.x += addButtonOffset.x
        result.y += addButtonOffset.y
        return result
    }

    static func layoutPreviewTask(at index: Int) -> LilyPadTaskItem {
        let categories: [LilyPadCategory] = [.hardSkills, .networking, .projects]
        let importances: [LilyPadImportance] = [.low, .medium, .high]

        return LilyPadTaskItem(
            title: "Slot \(index)",
            category: categories[index % categories.count],
            deadline: Date(),
            importance: importances[index % importances.count]
        )
    }

    static func elementWidth(category: LilyPadCategory, importance: LilyPadImportance) -> CGFloat {
        let base: CGFloat
        switch category {
        case .hardSkills:
            base = lilyPadBaseWidth
        case .networking:
            base = logBaseWidth
        case .projects:
            base = tortleBaseWidth
        }
        return base * importance.padScale
    }
}
