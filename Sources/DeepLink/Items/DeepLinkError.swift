
import Foundation

/// Ошибка при обработке ссылок
enum DeepLinkError: Error {
    /// Некорректное «сырое» значение
    case invalidRawValue
}
