
import Foundation

actor DeepLinkService<RawValue>: DeepLinkServiceProtocol where RawValue: Hashable & Sendable {
    private var state = DeepLinkServiceState<RawValue>()
    
    func register<Handler>(
        handler: Handler
    ) where Handler: DeepLinkHandlerProtocol, Handler.RawValue == RawValue {
        state.register(handler: handler)
    }
    
    func handle(rawValue: RawValue) -> DeepLinkHandlingResult {
        state.handle(rawValue: rawValue)
    }
}
