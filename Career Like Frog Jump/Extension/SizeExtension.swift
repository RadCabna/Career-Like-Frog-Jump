import SwiftUI
import UIKit

var screenWidth: CGFloat {
    AppScreenMetrics.width
}

var screenHeight: CGFloat {
    AppScreenMetrics.height
}

extension View {
    var screenWidth: CGFloat {
        AppScreenMetrics.width
    }

    var screenHeight: CGFloat {
        AppScreenMetrics.height
    }
}
