
import Foundation

/// Фабрика сервиса обработки ссылок
@MainActor
public final class DeepLinkServiceFactory {
    public init() { }
    
    /// Создает сервис обработки ссылок
    ///
    /// - Parameters:
    ///    - type: тип «сырого» значения, которое может быть обработано этим сервисом
    ///
    /// - Returns: сервис обработки ссылок
    public func create<RawValue: Hashable & Sendable>(
        type: RawValue.Type = RawValue.self
    ) -> some DeepLinkServiceProtocol<RawValue> {
        DeepLinkService()
    }
    
    /// Создает сервис обработки ссылок
    ///
    /// - Parameters:
    ///    - type: тип «сырого» значения, которое может быть обработано этим сервисом
    ///
    /// - Returns: сервис обработки ссылок
    public func createMainActorIsolated<RawValue: Hashable & Sendable>(
        type: RawValue.Type = RawValue.self
    ) -> some MainActorDeepLinkServiceProtocol<RawValue> {
        MainActorDeepLinkService()
    }
}
