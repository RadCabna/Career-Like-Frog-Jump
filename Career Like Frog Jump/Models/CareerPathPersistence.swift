import Foundation

struct CareerPathSnapshot: Codable, Equatable {
    var globalGoalTitle: String?
    var tasks: [LilyPadTaskItem]
    var halfHearts: Int
    var flyCoins: Int
    var frogSlotIndex: Int
    var frogRestingTaskID: UUID?
    var experiencePoints: Int
    var jumpsCompleted: Int
    var threatsDefeated: Int
    var equippedSkinID: FrogSkinID
    var ownedSkinIDs: [FrogSkinID]
    var progressFrozenUntil: Date?
    var confidenceBuffUntil: Date?
    var cognitiveLoadReduced: Bool
    var completedGoals: [CompletedGoalRecord]
    var lastFrogMovementAt: Date?
    var lastThreatDefeatedAt: Date?
    var radarActiveThreat: RiverThreat?
    var radarApproachingThreatKind: ThreatKind?
    var radarApproachingThreatStartedAt: Date?
    var jumpCompletionTimestamps: [Date]

    init(
        globalGoalTitle: String?,
        tasks: [LilyPadTaskItem],
        halfHearts: Int,
        flyCoins: Int,
        frogSlotIndex: Int,
        frogRestingTaskID: UUID?,
        experiencePoints: Int,
        jumpsCompleted: Int,
        threatsDefeated: Int,
        equippedSkinID: FrogSkinID,
        ownedSkinIDs: [FrogSkinID],
        progressFrozenUntil: Date?,
        confidenceBuffUntil: Date?,
        cognitiveLoadReduced: Bool,
        completedGoals: [CompletedGoalRecord] = [],
        lastFrogMovementAt: Date? = nil,
        lastThreatDefeatedAt: Date? = nil,
        radarActiveThreat: RiverThreat? = nil,
        radarApproachingThreatKind: ThreatKind? = nil,
        radarApproachingThreatStartedAt: Date? = nil,
        jumpCompletionTimestamps: [Date] = []
    ) {
        self.globalGoalTitle = globalGoalTitle
        self.tasks = tasks
        self.halfHearts = halfHearts
        self.flyCoins = flyCoins
        self.frogSlotIndex = frogSlotIndex
        self.frogRestingTaskID = frogRestingTaskID
        self.experiencePoints = experiencePoints
        self.jumpsCompleted = jumpsCompleted
        self.threatsDefeated = threatsDefeated
        self.equippedSkinID = equippedSkinID
        self.ownedSkinIDs = ownedSkinIDs
        self.progressFrozenUntil = progressFrozenUntil
        self.confidenceBuffUntil = confidenceBuffUntil
        self.cognitiveLoadReduced = cognitiveLoadReduced
        self.completedGoals = completedGoals
        self.lastFrogMovementAt = lastFrogMovementAt
        self.lastThreatDefeatedAt = lastThreatDefeatedAt
        self.radarActiveThreat = radarActiveThreat
        self.radarApproachingThreatKind = radarApproachingThreatKind
        self.radarApproachingThreatStartedAt = radarApproachingThreatStartedAt
        self.jumpCompletionTimestamps = jumpCompletionTimestamps
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        globalGoalTitle = try container.decodeIfPresent(String.self, forKey: .globalGoalTitle)
        tasks = try container.decode([LilyPadTaskItem].self, forKey: .tasks)
        halfHearts = try container.decode(Int.self, forKey: .halfHearts)
        flyCoins = try container.decode(Int.self, forKey: .flyCoins)
        frogSlotIndex = try container.decode(Int.self, forKey: .frogSlotIndex)
        frogRestingTaskID = try container.decodeIfPresent(UUID.self, forKey: .frogRestingTaskID)
        experiencePoints = try container.decode(Int.self, forKey: .experiencePoints)
        jumpsCompleted = try container.decode(Int.self, forKey: .jumpsCompleted)
        threatsDefeated = try container.decode(Int.self, forKey: .threatsDefeated)
        equippedSkinID = try container.decode(FrogSkinID.self, forKey: .equippedSkinID)
        ownedSkinIDs = try container.decode([FrogSkinID].self, forKey: .ownedSkinIDs)
        progressFrozenUntil = try container.decodeIfPresent(Date.self, forKey: .progressFrozenUntil)
        confidenceBuffUntil = try container.decodeIfPresent(Date.self, forKey: .confidenceBuffUntil)
        cognitiveLoadReduced = try container.decode(Bool.self, forKey: .cognitiveLoadReduced)
        completedGoals = try container.decodeIfPresent([CompletedGoalRecord].self, forKey: .completedGoals) ?? []
        lastFrogMovementAt = try container.decodeIfPresent(Date.self, forKey: .lastFrogMovementAt)
        lastThreatDefeatedAt = try container.decodeIfPresent(Date.self, forKey: .lastThreatDefeatedAt)
        radarActiveThreat = try container.decodeIfPresent(RiverThreat.self, forKey: .radarActiveThreat)
        radarApproachingThreatKind = try container.decodeIfPresent(ThreatKind.self, forKey: .radarApproachingThreatKind)
        radarApproachingThreatStartedAt = try container.decodeIfPresent(Date.self, forKey: .radarApproachingThreatStartedAt)
        jumpCompletionTimestamps = try container.decodeIfPresent([Date].self, forKey: .jumpCompletionTimestamps) ?? []
    }
}

enum CareerPathPersistence {
    private static let storageKey = "careerPathSnapshot.v1"

    static func load() -> CareerPathSnapshot? {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return nil }
        return try? JSONDecoder().decode(CareerPathSnapshot.self, from: data)
    }

    static func save(_ snapshot: CareerPathSnapshot) {
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
