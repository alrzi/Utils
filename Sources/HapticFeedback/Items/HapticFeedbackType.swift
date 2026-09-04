#if os(iOS) || targetEnvironment(macCatalyst)
//
//  HapticFeedbackType.swift
//  Tracker
//
//  Created by Александр Зиновьев on 26.08.2025.
//

public enum HapticFeedbackType {
    case notification(HapticNotificationFeedbackType)
    case selection
}

#endif
