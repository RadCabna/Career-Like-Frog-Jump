import Foundation
import SwiftUI

enum PomodoroPhase: Equatable {
    case work
    case rest
}

@MainActor
final class ThreatRadarViewModel: ObservableObject {
    @Published var activeThreat: RiverThreat?
    @Published private(set) var approachingThreatKind: ThreatKind?
    @Published var isPresentingShieldPicker = false
    @Published var selectedShield: ThreatShieldType?
    @Published var pomodoroPhase: PomodoroPhase = .work
    @Published var pomodoroSecondsRemaining = ThreatRadarConfig.standardPomodoroWorkSeconds
    @Published var isPomodoroRunning = false
    @Published var confidenceEntries: [String] = Array(repeating: "", count: ThreatRadarConfig.confidenceEntryCount)
    @Published var microStepEntries: [String] = Array(repeating: "", count: ThreatRadarConfig.microStepCount)
    @Published var victoryMessage: String?
    @Published var victoryRewardDetail: String?
    @Published var isPresentingVictory = false
    @Published var isDayOffActiveOnRadar = false

    private var approachingStartedAt: Date?
    private var frogInactivityCheckTask: Task<Void, Never>?
    private var pomodoroTask: Task<Void, Never>?
    private var store: CareerPathStore?

    var blinkingSectorIndex: Int? {
        activeThreat?.sectorIndex ?? approachingThreatKind?.sectorIndex
    }

    var isThreatApproaching: Bool {
        approachingThreatKind != nil && activeThreat == nil
    }

    var isRadarCalm: Bool {
        activeThreat == nil && !isThreatApproaching
    }

    var microStepsTargetTask: LilyPadTaskItem? {
        store?.currentFocusTask
    }

    var confidenceDiaryIsValid: Bool {
        confidenceEntries.allSatisfy {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    var microStepsIsValid: Bool {
        microStepEntries.allSatisfy {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    var pomodoroUsesBreakPhase: Bool {
        activeThreat?.kind.pomodoroUsesBreakPhase ?? false
    }

    var pomodoroWorkDuration: Int {
        guard let kind = activeThreat?.kind else {
            return ThreatRadarConfig.standardPomodoroWorkSeconds
        }
        return kind.pomodoroWorkSeconds
    }

    var pomodoroBreakDuration: Int {
        ThreatRadarConfig.standardPomodoroBreakSeconds
    }

    var pomodoroProgress: Double {
        let total = Double(pomodoroPhase == .work ? pomodoroWorkDuration : pomodoroBreakDuration)
        guard total > 0 else { return 0 }
        return 1 - Double(pomodoroSecondsRemaining) / total
    }

    func attach(store: CareerPathStore) {
        let shouldStartMonitoring = self.store == nil
        self.store = store
        store.clearExpiredProgressFreeze()
        store.clearExpiredConfidenceBuff()
        store.onBacklogCleanupCompleted = { [weak self] in
            self?.handleBacklogCleanupCompleted()
        }
        isDayOffActiveOnRadar = store.isProgressFrozen
        if shouldStartMonitoring {
            restoreThreatStateFromStore()
            startFrogInactivityMonitoring()
        }
        checkFrogInactivity()
    }

    func persistThreatStateToStore() {
        guard let store else { return }
        store.updateRadarThreatPersistence(
            activeThreat: activeThreat,
            approachingThreatKind: approachingThreatKind,
            approachingThreatStartedAt: approachingStartedAt
        )
    }

    func detachFromThreatTab() {
        stopPomodoroTimer()
    }

    func recordInteraction() {}

    func handleSectorTap(_ sectorIndex: Int) {
        guard let threat = activeThreat, threat.sectorIndex == sectorIndex else { return }
        isPresentingShieldPicker = true
    }

    func selectShield(_ shield: ThreatShieldType) {
        isPresentingShieldPicker = false

        switch shield {
        case .backlogCleanup:
            beginBacklogCleanup()
        case .focusTimer:
            selectedShield = shield
            resetPomodoro()
        case .confidenceDiary:
            selectedShield = shield
            confidenceEntries = Array(repeating: "", count: ThreatRadarConfig.confidenceEntryCount)
        case .lifebuoyRest:
            selectedShield = shield
        case .microSteps:
            selectedShield = shield
            loadMicroStepsForCurrentTask()
        }
    }

    func dismissShieldFlow() {
        selectedShield = nil
        stopPomodoroTimer()
    }

    func togglePomodoro() {
        if isPomodoroRunning {
            stopPomodoroTimer()
        } else {
            startPomodoroTimer()
        }
    }

    func submitConfidenceDiary() {
        guard confidenceDiaryIsValid else { return }
        defeatActiveThreat()
        dismissShieldFlow()
    }

    func submitMicroSteps() {
        guard microStepsIsValid, let task = microStepsTargetTask, let store else { return }
        let steps = microStepEntries.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        store.saveMicroSteps(for: task.id, steps: steps)
        defeatActiveThreat()
        dismissShieldFlow()
    }

    func activateDayOff() {
        let until = Date().addingTimeInterval(ThreatRadarConfig.dayOffDuration)
        store?.freezeProgress(until: until)
        isDayOffActiveOnRadar = true
        defeatActiveThreat()
        dismissShieldFlow()
    }

    private func beginBacklogCleanup() {
        store?.isBacklogCleanupActive = true
        store?.selectedTab = .lilyPadMap
        selectedShield = nil
        store?.onBacklogCleanupCompleted = { [weak self] in
            self?.handleBacklogCleanupCompleted()
        }
    }

    private func handleBacklogCleanupCompleted() {
        store?.onBacklogCleanupCompleted = nil
        guard activeThreat != nil else { return }
        defeatActiveThreat()
    }

    private func loadMicroStepsForCurrentTask() {
        guard let existing = microStepsTargetTask?.microSteps, !existing.isEmpty else {
            microStepEntries = Array(repeating: "", count: ThreatRadarConfig.microStepCount)
            return
        }

        var entries = existing
        while entries.count < ThreatRadarConfig.microStepCount {
            entries.append("")
        }
        microStepEntries = Array(entries.prefix(ThreatRadarConfig.microStepCount))
    }

    private func startFrogInactivityMonitoring() {
        frogInactivityCheckTask?.cancel()
        frogInactivityCheckTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(
                    for: .seconds(ThreatRadarConfig.frogInactivityCheckInterval)
                )
                guard !Task.isCancelled else { return }
                checkFrogInactivity()
            }
        }
    }

    private func checkFrogInactivity() {
        guard activeThreat == nil, selectedShield == nil else { return }
        guard let store else { return }
        guard !store.isProgressFrozen else { return }
        guard !store.isBacklogCleanupActive else { return }

        let idleDuration = Date().timeIntervalSince(store.lastFrogMovementAt)
        if idleDuration < ThreatRadarConfig.frogInactivityThreshold {
            clearApproachingThreat()
            return
        }

        if isWithinDefeatCooldown(store: store) {
            return
        }

        if approachingThreatKind == nil {
            let kind = nearestThreatKind(for: store)
            approachingThreatKind = kind
            approachingStartedAt = Date()
            persistThreatStateToStore()
            return
        }

        guard let startedAt = approachingStartedAt else { return }
        let approachDuration = Date().timeIntervalSince(startedAt)
        guard approachDuration >= ThreatRadarConfig.threatApproachWarningDuration else { return }

        if let kind = approachingThreatKind {
            registerThreat(kind: kind)
        }
    }

    private func isWithinDefeatCooldown(store: CareerPathStore) -> Bool {
        guard let lastDefeated = store.lastThreatDefeatedAt else { return false }
        return Date().timeIntervalSince(lastDefeated) < ThreatRadarConfig.threatRespawnCooldownAfterDefeat
    }

    private func nearestThreatKind(for store: CareerPathStore) -> ThreatKind {
        if let restingID = store.frogRestingTaskID,
           let task = store.tasks.first(where: { $0.id == restingID }) {
            return task.category.nearestThreatKind
        }
        if let focus = store.currentFocusTask {
            return focus.category.nearestThreatKind
        }
        return .burnoutBat
    }

    private func restoreThreatStateFromStore() {
        guard let store else { return }
        activeThreat = store.radarActiveThreat
        approachingThreatKind = store.radarApproachingThreatKind
        approachingStartedAt = store.radarApproachingThreatStartedAt
    }

    private func clearApproachingThreat() {
        approachingThreatKind = nil
        approachingStartedAt = nil
        persistThreatStateToStore()
    }

    private func registerThreat(kind: ThreatKind) {
        store?.takeDamage(halfHearts: ThreatRadarConfig.threatHeartPenalty)
        activeThreat = RiverThreat(kind: kind)
        clearApproachingThreat()
        persistThreatStateToStore()
    }

    private func defeatActiveThreat() {
        guard let threat = activeThreat, let store else { return }
        let kind = threat.kind
        var rewardParts: [String] = []

        if kind.defeatXP > 0 {
            store.addExperience(kind.defeatXP)
            rewardParts.append("+\(kind.defeatXP) XP · +\(kind.defeatXP) flies")
        }

        if kind.restoresThreatHealthOnDefeat {
            store.restoreThreatHealth()
            rewardParts.append("Health restored")
        }

        if kind.grantsConfidenceBuff {
            store.grantConfidenceBuff(
                until: Date().addingTimeInterval(ThreatRadarConfig.confidenceBuffDuration)
            )
            rewardParts.append("Confidence buff 24h")
        }

        if kind.grantsCognitiveLoadRelief {
            store.applyCognitiveLoadRelief()
            rewardParts.append("Cognitive load −5%")
        }

        store.recordThreatDefeated()
        activeThreat = nil
        clearApproachingThreat()
        persistThreatStateToStore()
        victoryMessage = kind.victoryMessage
        victoryRewardDetail = rewardParts.isEmpty ? nil : rewardParts.joined(separator: " · ")
        isPresentingVictory = true
    }

    private func resetPomodoro() {
        stopPomodoroTimer()
        pomodoroPhase = .work
        pomodoroSecondsRemaining = pomodoroWorkDuration
    }

    private func startPomodoroTimer() {
        stopPomodoroTimer()
        isPomodoroRunning = true
        pomodoroTask = Task { @MainActor in
            while !Task.isCancelled, isPomodoroRunning, pomodoroSecondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                pomodoroSecondsRemaining -= 1
            }
            guard !Task.isCancelled else { return }
            isPomodoroRunning = false
            handlePomodoroPhaseComplete()
        }
    }

    private func stopPomodoroTimer() {
        pomodoroTask?.cancel()
        pomodoroTask = nil
        isPomodoroRunning = false
    }

    private func handlePomodoroPhaseComplete() {
        defeatActiveThreat()
        dismissShieldFlow()
    }
}
