
import Foundation

/// Результат обработки ссылок
public enum DeepLinkHandlingResult: Equatable, Hashable, Sendable {
    /// Ссылка успешно обработана
    case success
    
    /// Запланирована обработка ссылки
    case enqueued
    
    /// При обработке ссылки произошла ошибка
    case failed
}
