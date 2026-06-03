import Combine
import Foundation

@MainActor
final class CareerPathStore: ObservableObject {
    private var persistenceCancellable: AnyCancellable?
    private var pendingSaveWorkItem: DispatchWorkItem?
    @Published var selectedTab: AppTab = .lilyPadMap
    @Published var globalGoalTitle: String?
    @Published var tasks: [LilyPadTaskItem] = []
    @Published var isEditingGoalInline = false
    @Published var isPresentingTaskCreation = false
    @Published var taskCreationDraft = PlaceLilyPadDraft()
    @Published var goalCreationDraft = ""
    @Published var halfHearts: Int = FrogHeartDisplay.maxHalfHearts
    @Published var flyCoins: Int = 0
    @Published var isPresentingJumpTask = false
    @Published var jumpTaskComment = ""
    @Published var activeJumpTaskID: UUID?
    @Published var frogSlotIndex: Int = -1
    @Published private(set) var frogRestingTaskID: UUID?
    @Published private(set) var activeJumpPlayback: ActiveJumpPlayback?
    private var jumpAnimationSequence: UInt64 = 0
    private var pendingRestingTaskIDAfterJump: UUID?
    @Published var experiencePoints: Int = 0
    @Published var jumpsCompleted: Int = 0
    @Published var jumpCompletionTimestamps: [Date] = []
    @Published var threatsDefeated: Int = 0
    @Published var equippedSkinID: FrogSkinID = .classic
    @Published var ownedSkinIDs: Set<FrogSkinID> = [.classic]
    @Published var levelUpPresentation: LevelUpPresentation?
    @Published var goalAchievedPresentation: GoalAchievedPresentation?
    @Published var completedGoals: [CompletedGoalRecord] = []
    @Published var isPresentingCelebrationProgressReview = false
    @Published var progressFrozenUntil: Date?
    @Published var confidenceBuffUntil: Date?
    @Published var cognitiveLoadReduced = false
    @Published var isBacklogCleanupActive = false
    @Published var lastFrogMovementAt = Date()
    @Published var lastThreatDefeatedAt: Date?
    @Published var radarActiveThreat: RiverThreat?
    @Published var radarApproachingThreatKind: ThreatKind?
    @Published var radarApproachingThreatStartedAt: Date?

    var onBacklogCleanupCompleted: (() -> Void)?

    init(loadPersistedState: Bool = true) {
        if loadPersistedState, let snapshot = CareerPathPersistence.load() {
            apply(snapshot)
        }
        selectedTab = Self.launchTab(hasGlobalGoal: hasGlobalGoal, hasTasks: !tasks.isEmpty)
        persistenceCancellable = objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.schedulePersistence()
            }
    }

    var hasGlobalGoal: Bool {
        guard let globalGoalTitle else { return false }
        return !globalGoalTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var canAddMoreTasks: Bool {
        activeTasks.count < RiverElementLayoutConfig.maxTaskCount
    }

    /// Tasks shown on Lily Pads and the river (excludes soft-deleted).
    var activeTasks: [LilyPadTaskItem] {
        tasks.filter { !$0.isDeleted }
    }

    /// Full task history for goal progress review (includes deleted and delegated).
    var goalProgressReviewTasks: [LilyPadTaskItem] {
        tasks
    }

    /// Lily Pads (menu 2) for onboarding; River (menu 1) when goal and tasks already exist.
    private static func launchTab(hasGlobalGoal: Bool, hasTasks: Bool) -> AppTab {
        hasGlobalGoal && hasTasks ? .turbulentRiver : .lilyPadMap
    }

    var shouldShowInlineGoalForm: Bool {
        !hasGlobalGoal || isEditingGoalInline
    }

    var activeRiverTasks: [LilyPadTaskItem] {
        activeTasks.filter { !$0.isCompleted && !$0.isDelegated }
    }

    /// Tasks visible on the river (completed tasks stay on their lily pad; delegated tasks are hidden).
    var riverTasks: [LilyPadTaskItem] {
        Array(activeTasks.filter { !$0.isDelegated }.prefix(RiverElementLayoutConfig.maxTaskCount))
    }

    var incompleteTasks: [LilyPadTaskItem] {
        activeRiverTasks
    }

    var currentFocusTask: LilyPadTaskItem? {
        activeRiverTasks.first
    }

    /// Next incomplete task to jump toward — prefers a lily pad ahead of the frog on the river.
    var jumpTargetTask: LilyPadTaskItem? {
        let incomplete = activeRiverTasks
        guard !incomplete.isEmpty else { return nil }

        let effectiveSlot: Int
        if frogSlotIndex < 0 || riverTasks.isEmpty {
            effectiveSlot = -1
        } else {
            effectiveSlot = min(frogSlotIndex, riverTasks.count - 1)
        }

        for task in incomplete {
            guard let riverIndex = riverTasks.firstIndex(where: { $0.id == task.id }) else { continue }
            if riverIndex > effectiveSlot {
                return task
            }
        }

        return incomplete.first
    }

    var isJumpAnimating: Bool {
        activeJumpPlayback != nil
    }

    var isProgressFrozen: Bool {
        guard let progressFrozenUntil else { return false }
        if Date() >= progressFrozenUntil {
            return false
        }
        return true
    }

    var hasConfidenceBuff: Bool {
        guard let confidenceBuffUntil else { return false }
        return Date() < confidenceBuffUntil
    }

    var equippedSkin: FrogSkinDefinition {
        FrogSkinCatalog.skin(for: equippedSkinID)
    }

    var evolutionStage: FrogEvolutionStage {
        FrogEvolutionCatalog.stage(forXP: experiencePoints)
    }

    var nextEvolutionStage: FrogEvolutionStage? {
        FrogEvolutionCatalog.nextStage(after: evolutionStage)
    }

    var evolutionProgress: Double {
        FrogEvolutionCatalog.progressToNextStage(xp: experiencePoints, current: evolutionStage)
    }

    var restingFrogAssetName: String {
        let skin = equippedSkin
        return isProgressFrozen ? skin.lifebuoyFrame : skin.restingFrame
    }

    var jumpFlightFrameNames: [String] {
        equippedSkin.jumpFrames
    }

    var jumpPadFrameName: String {
        equippedSkin.restingFrame
    }

    var activeJumpTask: LilyPadTaskItem? {
        guard let activeJumpTaskID else { return nil }
        return tasks.first { $0.id == activeJumpTaskID }
    }

    func requestGoalCreation() {
        goalCreationDraft = globalGoalTitle ?? ""
        isEditingGoalInline = true
        selectedTab = .lilyPadMap
    }

    func saveGlobalGoal() {
        let title = goalCreationDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        globalGoalTitle = title
        isEditingGoalInline = false
        goalCreationDraft = ""
    }

    func cancelInlineGoalEditing() {
        isEditingGoalInline = false
        if !hasGlobalGoal {
            goalCreationDraft = ""
        } else {
            goalCreationDraft = globalGoalTitle ?? ""
        }
    }

    func presentTaskCreation() {
        guard canAddMoreTasks else { return }
        taskCreationDraft = PlaceLilyPadDraft()
        isPresentingTaskCreation = true
    }

    func cancelTaskCreation() {
        isPresentingTaskCreation = false
        taskCreationDraft = PlaceLilyPadDraft()
    }

    func updateTaskCreationTitle(_ value: String) {
        if value.count > PlaceLilyPadDraft.titleCharacterLimit {
            taskCreationDraft.title = String(value.prefix(PlaceLilyPadDraft.titleCharacterLimit))
        } else {
            taskCreationDraft.title = value
        }
    }

    func saveTaskCreation() {
        guard taskCreationDraft.isValid, canAddMoreTasks else { return }

        let task = LilyPadTaskItem(
            title: taskCreationDraft.trimmedTitle,
            category: taskCreationDraft.category,
            deadline: taskCreationDraft.deadline,
            importance: taskCreationDraft.importance
        )
        tasks.append(task)
        cancelTaskCreation()
    }

    func deleteTask(_ task: LilyPadTaskItem) {
        let removedID = task.id
        if isBacklogCleanupActive {
            isBacklogCleanupActive = false
            onBacklogCleanupCompleted?()
        }
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isDeleted = true
        reconcileFrogPosition(removedTaskID: removedID)
    }

    func delegateTask(_ task: LilyPadTaskItem) {
        guard !task.isCompleted else { return }
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        let removedID = task.id
        if isBacklogCleanupActive {
            isBacklogCleanupActive = false
            onBacklogCleanupCompleted?()
        }
        tasks[index].isDelegated = true
        reconcileFrogPosition(removedTaskID: removedID)
    }

    func saveMicroSteps(for taskID: UUID, steps: [String]) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].microSteps = steps
    }

    private func reconcileFrogPosition(removedTaskID: UUID? = nil) {
        let river = riverTasks
        let fromSlot = frogSlotIndex
        let frogWasOnRemovedPad = removedTaskID != nil && removedTaskID == frogRestingTaskID

        if river.isEmpty {
            frogSlotIndex = -1
            frogRestingTaskID = nil
            return
        }

        // Another lily pad was removed — keep the frog on its task, only fix the slot index.
        if !frogWasOnRemovedPad,
           let restingID = frogRestingTaskID,
           let newIndex = river.firstIndex(where: { $0.id == restingID }) {
            frogSlotIndex = newIndex
            return
        }

        if !frogWasOnRemovedPad {
            clampFrogSlotIndexToRiver()
            syncFrogRestingTaskID()
            return
        }

        // The frog was on the delegated/deleted lily pad — land on the next task in that slot.
        let targetIndex: Int
        if fromSlot < 0 {
            targetIndex = 0
        } else if fromSlot < river.count {
            targetIndex = fromSlot
        } else {
            targetIndex = river.count - 1
        }

        guard !isJumpAnimating else {
            frogSlotIndex = targetIndex
            frogRestingTaskID = river[targetIndex].id
            return
        }

        let animationFromSlot = fromSlot > 0 ? fromSlot - 1 : -1
        guard animationFromSlot != targetIndex else {
            frogSlotIndex = targetIndex
            frogRestingTaskID = river[targetIndex].id
            return
        }

        let inPlace = fromSlot == targetIndex
        playJumpAnimation(
            fromSlotIndex: animationFromSlot,
            toSlotIndex: targetIndex,
            restingTaskID: river[targetIndex].id,
            inPlace: inPlace
        )
    }

    private func clampFrogSlotIndexToRiver() {
        let river = riverTasks
        guard frogSlotIndex >= river.count else { return }
        frogSlotIndex = max(river.count - 1, 0)
    }

    private func syncFrogRestingTaskID() {
        let river = riverTasks
        if frogSlotIndex >= 0, frogSlotIndex < river.count {
            frogRestingTaskID = river[frogSlotIndex].id
        } else {
            frogRestingTaskID = nil
        }
    }

    func presentJumpTask() {
        guard !isJumpAnimating, let task = jumpTargetTask else { return }
        activeJumpTaskID = task.id
        jumpTaskComment = ""
        isPresentingJumpTask = true
    }

    func cancelJumpTask() {
        isPresentingJumpTask = false
        activeJumpTaskID = nil
        jumpTaskComment = ""
    }

    func completeJumpTask() {
        guard !isJumpAnimating,
              let taskID = activeJumpTaskID,
              let taskIndex = tasks.firstIndex(where: { $0.id == taskID }),
              !tasks[taskIndex].isCompleted else { return }

        guard let riverSlotIndex = riverTasks.firstIndex(where: { $0.id == taskID }) else { return }

        let comment = jumpTaskComment.trimmingCharacters(in: .whitespacesAndNewlines)
        tasks[taskIndex].isCompleted = true
        tasks[taskIndex].completionComment = comment.isEmpty ? nil : comment
        addExperience(tasks[taskIndex].importance.flyCoinReward)
        recordJumpCompleted()

        isPresentingJumpTask = false
        activeJumpTaskID = nil
        jumpTaskComment = ""

        guard !hasCompletedAllNonDelegatedTasks else {
            frogRestingTaskID = taskID
            frogSlotIndex = riverSlotIndex
            return
        }

        let toSlot = riverSlotIndex
        let (fromSlot, inPlace) = jumpSlotsForTaskCompletion(targetRiverIndex: toSlot)

        let jumpFromSlot = fromSlot
        let jumpToSlot = toSlot
        let jumpInPlace = inPlace

        Task { @MainActor in
            await self.waitForJumpAnimationToFinish()
            guard !self.isJumpAnimating else { return }
            self.playJumpAnimation(
                fromSlotIndex: jumpFromSlot,
                toSlotIndex: jumpToSlot,
                restingTaskID: taskID,
                inPlace: jumpInPlace
            )
        }
    }

    private func waitForJumpAnimationToFinish() async {
        var spins = 0
        while isJumpAnimating, spins < 120 {
            try? await Task.sleep(for: .milliseconds(16))
            spins += 1
        }
        try? await Task.sleep(for: .milliseconds(32))
    }

    private func jumpSlotsForTaskCompletion(targetRiverIndex: Int) -> (from: Int, inPlace: Bool) {
        let currentSlot: Int
        if frogSlotIndex < 0 || riverTasks.isEmpty {
            currentSlot = -1
        } else {
            currentSlot = min(frogSlotIndex, riverTasks.count - 1)
        }

        if currentSlot == targetRiverIndex {
            return (targetRiverIndex, true)
        }

        var fromSlot = jumpAnimationFromSlot(to: targetRiverIndex)
        if fromSlot == targetRiverIndex {
            fromSlot = targetRiverIndex > 0 ? targetRiverIndex - 1 : -1
        }
        return (fromSlot, false)
    }

    var hasCompletedAllNonDelegatedTasks: Bool {
        let active = activeTasks.filter { !$0.isDelegated }
        guard !active.isEmpty else { return false }
        return active.allSatisfy(\.isCompleted)
    }

    var canCelebrateGoalAchievement: Bool {
        hasGlobalGoal
            && hasCompletedAllNonDelegatedTasks
            && goalAchievedPresentation == nil
            && !isPresentingCelebrationProgressReview
    }

    func handleJumpButtonTap() {
        if canCelebrateGoalAchievement {
            presentGoalAchievedOverlay()
            return
        }
        presentJumpTask()
    }

    func presentGoalAchievedOverlay() {
        guard let title = globalGoalTitle?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else { return }
        goalAchievedPresentation = GoalAchievedPresentation(
            completedGoalTitle: title,
            frogAssetName: evolutionStage.assetName
        )
    }

    func presentCelebrationProgressReview() {
        goalAchievedPresentation = nil
        isPresentingCelebrationProgressReview = true
    }

    func beginNewGoalAfterAchievement() {
        archiveCurrentGoalToHistory()
        goalAchievedPresentation = nil
        isPresentingCelebrationProgressReview = false
        globalGoalTitle = nil
        tasks = []
        frogSlotIndex = -1
        frogRestingTaskID = nil
        clearJumpAnimationState()
        isEditingGoalInline = true
        goalCreationDraft = ""
        selectedTab = .lilyPadMap
    }

    private func archiveCurrentGoalToHistory() {
        guard let title = globalGoalTitle?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else { return }
        let record = CompletedGoalRecord(
            title: title,
            completedAt: Date(),
            tasks: tasks
        )
        completedGoals.insert(record, at: 0)
    }

    private func jumpAnimationFromSlot(to targetRiverIndex: Int) -> Int {
        if frogSlotIndex < 0 || riverTasks.isEmpty {
            return -1
        }

        let currentSlot = min(frogSlotIndex, riverTasks.count - 1)
        guard currentSlot != targetRiverIndex else {
            return targetRiverIndex > 0 ? targetRiverIndex - 1 : -1
        }

        return currentSlot
    }

    func completeJumpPlaybackIfNeeded(sequence: UInt64) {
        guard activeJumpPlayback?.animation.sequence == sequence else { return }
        applyJumpLandingFromActivePlayback()
    }

    private func applyJumpLandingFromActivePlayback() {
        guard let playback = activeJumpPlayback else { return }
        frogSlotIndex = playback.animation.toSlotIndex
        if let restingID = pendingRestingTaskIDAfterJump {
            frogRestingTaskID = restingID
            pendingRestingTaskIDAfterJump = nil
        } else {
            syncFrogRestingTaskID()
        }
        if frogSlotIndex < 0 {
            frogRestingTaskID = nil
        }
        clearJumpAnimationState()
        clampFrogSlotIndexToRiver()
    }

    private func playJumpAnimation(
        fromSlotIndex: Int,
        toSlotIndex: Int,
        restingTaskID: UUID? = nil,
        inPlace: Bool = false
    ) {
        if activeJumpPlayback != nil {
            applyJumpLandingFromActivePlayback()
        }

        jumpAnimationSequence += 1
        let sequence = jumpAnimationSequence
        pendingRestingTaskIDAfterJump = restingTaskID

        let skin = equippedSkin
        let animation = RiverJumpAnimation(
            fromSlotIndex: fromSlotIndex,
            toSlotIndex: toSlotIndex,
            sequence: sequence
        )

        activeJumpPlayback = ActiveJumpPlayback(
            animation: animation,
            flightFrameNames: skin.jumpFrames,
            restingPadFrameName: skin.restingFrame,
            homeRestingFrameName: isProgressFrozen ? skin.lifebuoyFrame : skin.restingFrame,
            inPlace: inPlace,
            startedAt: Date()
        )
    }

    private func clearJumpAnimationState() {
        activeJumpPlayback = nil
        pendingRestingTaskIDAfterJump = nil
    }


    func takeDamage(halfHearts amount: Int = 1) {
        halfHearts = max(0, halfHearts - amount)
    }

    func restoreHearts(halfHearts amount: Int = 2) {
        self.halfHearts = min(self.halfHearts + amount, FrogHeartDisplay.maxHalfHearts)
    }

    func restoreThreatHealth() {
        restoreHearts(halfHearts: ThreatRadarConfig.threatHeartRestore)
    }

    func grantConfidenceBuff(until date: Date) {
        confidenceBuffUntil = date
    }

    func clearExpiredConfidenceBuff() {
        guard let confidenceBuffUntil, Date() >= confidenceBuffUntil else { return }
        self.confidenceBuffUntil = nil
    }

    func applyCognitiveLoadRelief() {
        cognitiveLoadReduced = true
    }

    func addExperience(_ amount: Int) {
        guard amount > 0 else { return }
        let previousStage = evolutionStage
        experiencePoints += amount
        flyCoins += amount
        checkEvolutionLevelUp(previousStage: previousStage)
    }

    func recordJumpCompleted() {
        jumpsCompleted += 1
        lastFrogMovementAt = Date()
        jumpCompletionTimestamps.append(Date())
        trimJumpCompletionHistory()
    }

    private func trimJumpCompletionHistory() {
        let calendar = Calendar.current
        guard let cutoff = calendar.date(byAdding: .weekOfYear, value: -52, to: Date()) else { return }
        jumpCompletionTimestamps = jumpCompletionTimestamps.filter { $0 >= cutoff }
    }

    func recordThreatDefeated() {
        threatsDefeated += 1
        lastThreatDefeatedAt = Date()
    }

    func ownsSkin(_ skinID: FrogSkinID) -> Bool {
        ownedSkinIDs.contains(skinID)
    }

    func canPurchaseSkin(_ skin: FrogSkinDefinition) -> Bool {
        !ownsSkin(skin.id) && flyCoins >= skin.price
    }

    @discardableResult
    func purchaseSkin(_ skinID: FrogSkinID) -> Bool {
        let skin = FrogSkinCatalog.skin(for: skinID)
        guard !skin.isDefault, !ownsSkin(skinID), flyCoins >= skin.price else { return false }
        flyCoins -= skin.price
        ownedSkinIDs.insert(skinID)
        equippedSkinID = skinID
        return true
    }

    func equipSkin(_ skinID: FrogSkinID) {
        guard ownsSkin(skinID) else { return }
        equippedSkinID = skinID
    }

    func dismissLevelUpPresentation() {
        levelUpPresentation = nil
    }

    private func checkEvolutionLevelUp(previousStage: FrogEvolutionStage) {
        let newStage = evolutionStage
        guard newStage.level > previousStage.level else { return }
        levelUpPresentation = LevelUpPresentation(fromStage: previousStage, toStage: newStage)
    }

    func freezeProgress(until date: Date) {
        progressFrozenUntil = date
    }

    func clearExpiredProgressFreeze() {
        guard let progressFrozenUntil, Date() >= progressFrozenUntil else { return }
        self.progressFrozenUntil = nil
    }

    func requestGoalEdit() {
        goalCreationDraft = globalGoalTitle ?? ""
        isEditingGoalInline = true
    }

    func updateGoalDraft(_ value: String) {
        if value.count > 60 {
            goalCreationDraft = String(value.prefix(60))
        } else {
            goalCreationDraft = value
        }
    }

    func flushPersistence() {
        pendingSaveWorkItem?.cancel()
        pendingSaveWorkItem = nil
        CareerPathPersistence.save(makeSnapshot())
    }

    private func schedulePersistence() {
        pendingSaveWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            CareerPathPersistence.save(self.makeSnapshot())
        }
        pendingSaveWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: work)
    }

    private func makeSnapshot() -> CareerPathSnapshot {
        CareerPathSnapshot(
            globalGoalTitle: globalGoalTitle,
            tasks: tasks,
            halfHearts: halfHearts,
            flyCoins: flyCoins,
            frogSlotIndex: frogSlotIndex,
            frogRestingTaskID: frogRestingTaskID,
            experiencePoints: experiencePoints,
            jumpsCompleted: jumpsCompleted,
            threatsDefeated: threatsDefeated,
            equippedSkinID: equippedSkinID,
            ownedSkinIDs: Array(ownedSkinIDs),
            progressFrozenUntil: progressFrozenUntil,
            confidenceBuffUntil: confidenceBuffUntil,
            cognitiveLoadReduced: cognitiveLoadReduced,
            completedGoals: completedGoals,
            lastFrogMovementAt: lastFrogMovementAt,
            lastThreatDefeatedAt: lastThreatDefeatedAt,
            radarActiveThreat: radarActiveThreat,
            radarApproachingThreatKind: radarApproachingThreatKind,
            radarApproachingThreatStartedAt: radarApproachingThreatStartedAt,
            jumpCompletionTimestamps: jumpCompletionTimestamps
        )
    }

    func updateRadarThreatPersistence(
        activeThreat: RiverThreat?,
        approachingThreatKind: ThreatKind?,
        approachingThreatStartedAt: Date?
    ) {
        radarActiveThreat = activeThreat
        radarApproachingThreatKind = approachingThreatKind
        radarApproachingThreatStartedAt = approachingThreatStartedAt
    }

    private func apply(_ snapshot: CareerPathSnapshot) {
        globalGoalTitle = snapshot.globalGoalTitle
        tasks = snapshot.tasks
        halfHearts = snapshot.halfHearts
        flyCoins = snapshot.flyCoins
        frogSlotIndex = snapshot.frogSlotIndex
        frogRestingTaskID = snapshot.frogRestingTaskID
        experiencePoints = snapshot.experiencePoints
        jumpsCompleted = snapshot.jumpsCompleted
        threatsDefeated = snapshot.threatsDefeated
        equippedSkinID = snapshot.equippedSkinID
        ownedSkinIDs = Set(snapshot.ownedSkinIDs)
        if ownedSkinIDs.isEmpty {
            ownedSkinIDs = [.classic]
        }
        if !ownedSkinIDs.contains(equippedSkinID) {
            equippedSkinID = .classic
        }
        progressFrozenUntil = snapshot.progressFrozenUntil
        confidenceBuffUntil = snapshot.confidenceBuffUntil
        cognitiveLoadReduced = snapshot.cognitiveLoadReduced
        completedGoals = snapshot.completedGoals
        lastFrogMovementAt = snapshot.lastFrogMovementAt ?? Date()
        lastThreatDefeatedAt = snapshot.lastThreatDefeatedAt
        radarActiveThreat = snapshot.radarActiveThreat
        radarApproachingThreatKind = snapshot.radarApproachingThreatKind
        radarApproachingThreatStartedAt = snapshot.radarApproachingThreatStartedAt
        jumpCompletionTimestamps = snapshot.jumpCompletionTimestamps
        trimJumpCompletionHistory()
    }
}

extension CareerPathStore {
    static var previewWithGoalAndTasks: CareerPathStore {
        let store = CareerPathStore(loadPersistedState: false)
        store.globalGoalTitle = "Senior Developer"
        store.tasks = [
            LilyPadTaskItem(title: "Course", category: .hardSkills, deadline: Date(), importance: .medium),
            LilyPadTaskItem(title: "Mentor", category: .networking, deadline: Date(), importance: .high)
        ]
        return store
    }
}
