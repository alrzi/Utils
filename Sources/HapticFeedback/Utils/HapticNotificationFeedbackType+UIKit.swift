#if os(iOS) || targetEnvironment(macCatalyst)
//
//  HapticNotificationFeedbackType+UIKit.swift
//  Utils
//

import UIKit

extension HapticNotificationFeedbackType {
    var uiKitFeedbackType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .error:
            .error
        case .success:
            .success
        case .warning:
            .warning
        }
    }
}

#endif
