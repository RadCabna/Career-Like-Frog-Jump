import SwiftUI

struct RiverGameSceneView: View {
    @EnvironmentObject private var store: CareerPathStore

    private let layout = RiverSceneLayout()

    @State private var jumpStartDate: Date?

    private var displayedSlots: [RiverLayoutSlot] {
        if RiverElementLayoutConfig.showsAllLayoutSlots {
            return (0..<RiverElementLayoutConfig.maxTaskCount).map { index in
                RiverLayoutSlot(
                    index: index,
                    task: RiverElementLayoutConfig.layoutPreviewTask(at: index)
                )
            }
        }

        return Array(store.riverTasks.enumerated()).map { index, task in
            RiverLayoutSlot(index: index, task: task)
        }
    }

    private var showsFrogOnHomePad: Bool {
        store.frogSlotIndex < 0 && store.jumpAnimation == nil
    }

    private var frogTaskSlot: RiverLayoutSlot? {
        guard store.frogSlotIndex >= 0 else { return nil }
        return displayedSlots.first { $0.index == store.frogSlotIndex }
    }

    private var backgroundTaskSlots: [RiverLayoutSlot] {
        displayedSlots.filter { slot in
            store.jumpAnimation != nil || slot.index != store.frogSlotIndex
        }
    }

    var body: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                riverSceneLayer
                    .ignoresSafeArea()
            }
            .overlay {
                RiverSceneHUDView()
            }
            .sheet(isPresented: $store.isPresentingJumpTask) {
                if let task = store.activeJumpTask {
                    JumpTaskSheetView(
                        task: task,
                        comment: $store.jumpTaskComment,
                        onComplete: store.completeJumpTask,
                        onCancel: store.cancelJumpTask
                    )
                }
            }
            .onChange(of: store.jumpAnimation?.id) { _, newID in
                if newID != nil {
                    jumpStartDate = Date()
                    scheduleJumpCompletion()
                } else {
                    jumpStartDate = nil
                }
            }
    }

    private var riverSceneLayer: some View {
        ZStack {
            if !showsFrogOnHomePad {
                RiverFrogHomePadView(showsFrog: false)
                    .position(layout.supportPoint(forSlotIndex: -1))
            }

            ForEach(backgroundTaskSlots) { slot in
                RiverLayoutSlotView(
                    slot: slot,
                    showsRestingFrog: false,
                    showsIndexLabel: RiverElementLayoutConfig.showsAllLayoutSlots
                )
                .position(layout.supportPoint(forSlotIndex: slot.index))
            }

            if showsFrogOnHomePad {
                RiverFrogHomePadView(showsFrog: true)
                    .position(layout.supportPoint(forSlotIndex: -1))
            } else if let frogSlot = frogTaskSlot, store.jumpAnimation == nil {
                RiverLayoutSlotView(
                    slot: frogSlot,
                    showsRestingFrog: true,
                    showsIndexLabel: RiverElementLayoutConfig.showsAllLayoutSlots
                )
                .position(layout.supportPoint(forSlotIndex: frogSlot.index))
            }

            if let jump = store.jumpAnimation, let startDate = jumpStartDate {
                TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
                    let elapsed = timeline.date.timeIntervalSince(startDate)
                    let phase = RiverJumpTimeline.phase(elapsed: elapsed)

                    Group {
                        switch phase {
                        case .preDelay:
                            RiverJumpingFrogView(imageName: "frog1_5")
                                .position(layout.frogPoint(forSlotIndex: jump.fromSlotIndex))

                        case .flying:
                            let progress = RiverJumpTimeline.flightProgress(elapsed: elapsed)
                            RiverJumpingFrogView(imageName: FrogJumpSprite.frameName(for: progress))
                                .position(jumpingFrogPoint(progress: progress, jump: jump))

                        case .landingHold:
                            if RiverElementLayoutConfig.jumpLandingHold > 0 {
                                RiverJumpingFrogView(imageName: "frog1_1")
                                    .position(layout.frogPoint(forSlotIndex: jump.toSlotIndex))
                            }
                        }
                    }
                }
            }
        }
        .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func jumpingFrogPoint(progress: CGFloat, jump: RiverJumpAnimation) -> CGPoint {
        let from = layout.frogPoint(forSlotIndex: jump.fromSlotIndex)
        let to = layout.frogPoint(forSlotIndex: jump.toSlotIndex)
        let arcHeight = RiverJumpArc.arcHeight(from: from, to: to)

        return RiverJumpArc.point(
            progress: progress,
            from: from,
            to: to,
            arcHeight: arcHeight
        )
    }

    private func scheduleJumpCompletion() {
        let duration = RiverElementLayoutConfig.jumpTotalDuration

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(duration))
            guard store.jumpAnimation != nil else { return }
            store.finishJumpAnimation()
            jumpStartDate = nil
        }
    }
}

private struct RiverLayoutSlot: Identifiable {
    let index: Int
    let task: LilyPadTaskItem

    var id: Int { index }
}

private struct RiverLayoutSlotView: View {
    let slot: RiverLayoutSlot
    let showsRestingFrog: Bool
    let showsIndexLabel: Bool

    private var wobbleIndex: Int {
        slot.index + 2
    }

    var body: some View {
        ZStack {
            RiverFloatingSupportView(task: slot.task)

            if showsRestingFrog {
                Image("frog1_5")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: RiverElementLayoutConfig.frogWidth)
                    .offset(y: RiverElementLayoutConfig.frogOnSupportYOffset)
            }

            if showsIndexLabel {
                Text("\(slot.index)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.black.opacity(0.55), in: Capsule())
                    .offset(y: -screenHeight * 0.028)
            }
        }
        .waterWobble(
            index: wobbleIndex,
            amplitude: RiverElementLayoutConfig.taskWobbleAmplitude
        )
    }
}

#Preview("Scene") {
    RiverGameSceneView()
        .environmentObject(CareerPathStore.previewWithGoalAndTasks)
        .tabScreenBackground(.river)
}

#Preview("Tab") {
    MainTabView()
        .environmentObject(CareerPathStore.previewWithGoalAndTasks)
}
