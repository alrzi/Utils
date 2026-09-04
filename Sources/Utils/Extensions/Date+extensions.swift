//
//  Date+extensions.swift
//  Utils
//
//  Created by Александр Зиновьев on 3/20/26.
//

import Foundation

public extension Date {
    func next(
        matching components: DateComponents,
        matchingPolicy: Calendar.MatchingPolicy = .nextTime,
        repeatedTimePolicy: Calendar.RepeatedTimePolicy = .first,
        direction: Calendar.SearchDirection = .forward,
        calendar: Calendar = .current
    ) -> Date? {
        calendar.nextDate(
            after: self,
            matching: components,
            matchingPolicy: matchingPolicy,
            repeatedTimePolicy: repeatedTimePolicy,
            direction: direction
        )
    }

    func distance(to other: Date, in component: Calendar.Component, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([component], from: self, to: other).value(for: component) ?? 0
    }

    func advanced(by value: Int, _ component: Calendar.Component, calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self) ?? self
    }

    func components(
        _ components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second],
        calendar: Calendar = .current
    ) -> DateComponents {
        calendar.dateComponents(components, from: self)
    }

    /// Проверяет, относится ли дата к сегодняшнему дню.
    ///
    /// - Parameter calendar: Календарь для проверки (по умолчанию `.current`).
    var isInToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Возвращает начало дня (00:00:00) для этой даты.
    ///
    /// Полезно для сравнения дат без учета времени.
    /// - Parameter calendar: Календарь для расчета (по умолчанию `.current`).
    func startOfDay(calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }

    /// Проверяет, является ли эта дата следующим календарным днем относительно другой даты.
    ///
    /// Например: `today.isNextDay(after: yesterday)` вернет `true`.
    /// - Parameters:
    ///   - date: Базовая дата для проверки.
    ///   - calendar: Календарь для расчета (по умолчанию `.current`).
    func isNextDay(after date: Date, calendar: Calendar = .current) -> Bool {
        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: date) else {
            return false
        }

        return calendar.isDate(self, inSameDayAs: nextDay)
    }

    func component(_ component: Calendar.Component) -> Int {
        Calendar.current.component(component, from: self)
    }
}
