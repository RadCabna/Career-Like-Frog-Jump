import Foundation

enum AppBackgroundKind: Equatable {
    case river
    case sky(bottomImageName: String)
}

enum AppBackgroundStore {
    static let modalFormBackground = AppBackgroundKind.sky(bottomImageName: "cityBG")

    private static var skyBottomImages: [AppTab: String] = [:]

    static func kind(for tab: AppTab) -> AppBackgroundKind {
        switch tab {
        case .turbulentRiver, .lilyPadMap:
            return .river
        case .threatRadar, .frogEvolution, .jumpStatistics:
            return .sky(bottomImageName: skyBottomImage(for: tab))
        }
    }

    private static func skyBottomImage(for tab: AppTab) -> String {
        if let cached = skyBottomImages[tab] {
            return cached
        }
        let imageName = Bool.random() ? "cityBG" : "forestBG"
        skyBottomImages[tab] = imageName
        return imageName
    }
}
