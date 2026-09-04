
import Foundation

/// Результат работы обработчика ссылок
public enum HandlingResult: Sendable {
    /// Обработана
    case handled
    
    /// Частично обработана
    case partiallyHandled
    
    /// Не обработана
    case notHandled((any Error)?)
}
