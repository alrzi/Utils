#if os(iOS) || targetEnvironment(macCatalyst)
//
//  VibrationFeedbackManager.swift
//  Tracker
//
//  Created by Александр Зиновьев on 22.03.2025.
//

import UIKit

public protocol VibrationFeedbackManaging: AnyObject {
    @MainActor
    func makeVibration(for type: HapticFeedbackType)
}

public final class VibrationFeedbackManager: VibrationFeedbackManaging {
    private let generatorProvider: @Sendable @MainActor () -> UINotificationFeedbackGenerator
    private let selectionGenerator: @Sendable @MainActor () -> UISelectionFeedbackGenerator
    
    public init(
        generatorProvider: @escaping @Sendable @MainActor () -> UINotificationFeedbackGenerator,
        selectionGenerator: @escaping @Sendable @MainActor () -> UISelectionFeedbackGenerator
    ) {
        self.generatorProvider = generatorProvider
        self.selectionGenerator = selectionGenerator
    }
    
    public func makeVibration(for type: HapticFeedbackType) {
        switch type {
        case .selection: makeSelectionVibration()
        case .notification(let feedbackType): makeNotificationVibration(for: feedbackType)
        }
    }

    // MARK: - Private methods

    @MainActor
    private func makeSelectionVibration() {
        let selectionGenerator = selectionGenerator()

        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
    }

    @MainActor
    private func makeNotificationVibration(for type: HapticNotificationFeedbackType) {
        let generator = generatorProvider()

        generator.prepare()
        generator.notificationOccurred(type.uiKitFeedbackType)
    }
}


#endif
