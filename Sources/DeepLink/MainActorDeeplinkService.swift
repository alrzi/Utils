
import Foundation

/// Сервис обработки ссылок с изоляцией на главном потоке
public protocol MainActorDeepLinkServiceProtocol<RawValue>: DeepLinkServiceProtocol {
    /// Регистрирует обработчик ссылок
    ///
    /// - Parameters:
    ///    - handler: обработчик ссылок, который нужно зарегистрировать
    ///
    @MainActor
    func register<Handler>(
        handler: Handler
    ) where Handler: DeepLinkHandlerProtocol, Handler.RawValue == RawValue
    
    /// Обрабатывает «сырое» значение ссылки
    ///
    /// - Parameters:
    ///    - rawValue: «сырое» значение, которое нужно обработать
    ///
    /// - Returns: результат обработки
    @MainActor
    @discardableResult
    func handle(rawValue: RawValue) -> DeepLinkHandlingResult
}

@MainActor
final class MainActorDeepLinkService<RawValue: Hashable & Sendable>: MainActorDeepLinkServiceProtocol {
	private var state = DeepLinkServiceState<RawValue>()
    
    func register<Handler>(handler: Handler) where Handler: DeepLinkHandlerProtocol, RawValue == Handler.RawValue {
        state.register(handler: handler)
    }
    
    func handle(rawValue: RawValue) -> DeepLinkHandlingResult {
        state.handle(rawValue: rawValue)
    }
}
