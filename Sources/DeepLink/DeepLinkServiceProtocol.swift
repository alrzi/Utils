
import Foundation

/// Сервис обработки ссылок
public protocol DeepLinkServiceProtocol<RawValue>: Sendable {
    /// Тип «сырого» значения, которое может быть обработано этим сервисом
    associatedtype RawValue: Sendable
    
    /// Регистрирует обработчик ссылок
    ///
    /// - Parameters:
    ///    - handler: обработчик ссылок, который нужно зарегистрировать
    ///
    func register<Handler>(
        handler: Handler
    ) async where Handler: DeepLinkHandlerProtocol, Handler.RawValue == RawValue
    
    /// Обрабатывает «сырое» значение ссылки
    ///
    /// - Parameters:
    ///    - rawValue: «сырое» значение, которое нужно обработать
    ///
    /// - Returns: результат обработки
    @discardableResult
    func handle(rawValue: RawValue) async -> DeepLinkHandlingResult
}
