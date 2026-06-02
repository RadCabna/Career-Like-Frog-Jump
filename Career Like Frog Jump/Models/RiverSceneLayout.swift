import CoreGraphics

struct RiverSceneLayout {
    let centerX: CGFloat
    let frogAnchorY: CGFloat
    let minElementY: CGFloat

    init() {
        let frogHalfHeight = RiverElementLayoutConfig.lilyPadBaseWidth * 0.48

        centerX = AppScreenMetrics.width * 0.5
        frogAnchorY = AppScreenMetrics.height
            - RiverElementLayoutConfig.frogPadBottomMargin
            - frogHalfHeight
        minElementY = AppScreenMetrics.safeAreaTop + RiverElementLayoutConfig.topContentMargin
    }

    func position(xOffset: CGFloat, yOffset: CGFloat) -> CGPoint {
        CGPoint(
            x: centerX + xOffset,
            y: max(
                frogAnchorY + yOffset - RiverElementLayoutConfig.sceneVerticalLift,
                minElementY
            )
        )
    }

    func supportPoint(forSlotIndex slotIndex: Int) -> CGPoint {
        let offset = RiverElementLayoutConfig.slotOffset(for: slotIndex)
        return position(xOffset: offset.x, yOffset: offset.y)
    }

    func frogPoint(forSlotIndex slotIndex: Int) -> CGPoint {
        let offset = RiverElementLayoutConfig.slotOffset(for: slotIndex)
        let bodyOffset = slotIndex < 0
            ? RiverElementLayoutConfig.frogHomeBodyYOffset
            : RiverElementLayoutConfig.frogOnSupportYOffset
        return position(xOffset: offset.x, yOffset: offset.y + bodyOffset)
    }
}
