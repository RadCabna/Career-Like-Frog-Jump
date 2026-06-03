import SwiftUI

struct RiverGameSceneView: View {
    @EnvironmentObject private var store: CareerPathStore
    @EnvironmentObject private var threatRadarViewModel: ThreatRadarViewModel

    private let layout = RiverSceneLayout()

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

    private var effectiveFrogSlotIndex: Int {
        guard store.frogSlotIndex >= 0, !displayedSlots.isEmpty else { return -1 }
        return min(store.frogSlotIndex, displayedSlots.count - 1)
    }

    private var showsFrogOnHomePad: Bool {
        store.frogSlotIndex < 0 && store.activeJumpPlayback == nil
    }

    private var frogTaskSlot: RiverLayoutSlot? {
        guard effectiveFrogSlotIndex >= 0 else { return nil }
        return displayedSlots.first { $0.index == effectiveFrogSlotIndex }
    }

    private var backgroundTaskSlots: [RiverLayoutSlot] {
        displayedSlots.filter { slot in
            store.activeJumpPlayback != nil || slot.index != effectiveFrogSlotIndex
        }
    }

    private var restingFrogSlotIndex: Int? {
        guard store.activeJumpPlayback == nil else { return nil }
        if showsFrogOnHomePad { return -1 }
        if frogTaskSlot != nil { return effectiveFrogSlotIndex }
        return nil
    }

    private var padRippleStyle: PadRippleWavesView.Style? {
        guard restingFrogSlotIndex != nil else { return nil }
        if store.isProgressFrozen { return .lifebuoy }
        if threatRadarViewModel.isThreatApproaching || threatRadarViewModel.activeThreat != nil {
            return .threat
        }
        return nil
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

            if let slotIndex = restingFrogSlotIndex, let rippleStyle = padRippleStyle {
                PadRippleWavesView(style: rippleStyle)
                    .position(layout.supportPoint(forSlotIndex: slotIndex))
            }

            if showsFrogOnHomePad {
                RiverFrogHomePadView(
                    showsFrog: true,
                    frogAssetName: store.restingFrogAssetName
                )
                .position(layout.supportPoint(forSlotIndex: -1))
            } else if let frogSlot = frogTaskSlot, store.activeJumpPlayback == nil {
                RiverLayoutSlotView(
                    slot: frogSlot,
                    showsRestingFrog: true,
                    frogAssetName: store.restingFrogAssetName,
                    showsIndexLabel: RiverElementLayoutConfig.showsAllLayoutSlots
                )
                .position(layout.supportPoint(forSlotIndex: frogSlot.index))
            }

            if let playback = store.activeJumpPlayback {
                RiverJumpAnimationLayer(
                    playback: playback,
                    layout: layout,
                    onComplete: store.completeJumpPlaybackIfNeeded
                )
                .id(playback.animation.sequence)
                .zIndex(10)
            }
        }
        .frame(width: AppScreenMetrics.width, height: AppScreenMetrics.height)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    var frogAssetName: String = "frog1_1"
    let showsIndexLabel: Bool

    private var wobbleIndex: Int {
        slot.index + 2
    }

    var body: some View {
        ZStack {
            RiverFloatingSupportView(task: slot.task)

            if showsRestingFrog {
                Image(frogAssetName)
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
        .environmentObject(ThreatRadarViewModel())
        .tabScreenBackground(.river)
}

#Preview("Tab") {
    MainTabView()
        .environmentObject(CareerPathStore.previewWithGoalAndTasks)
        .environmentObject(ThreatRadarViewModel())
}
