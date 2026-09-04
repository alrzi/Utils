
import Foundation

struct DeepLinkServiceState<RawValue>: Sendable where RawValue: Hashable & Sendable {
    private var handlers: [WeakHandler] = []
    private var rawValueQueue: [RawValue] = []
    
    mutating func register<Handler>(
        handler: Handler
    ) where Handler: DeepLinkHandlerProtocol, Handler.RawValue == RawValue {
        handlers.append(WeakHandler(handler))
        
        attemptToHandleQueuedRawValues(with: handler)
    }
    
    mutating func handle(rawValue: RawValue) -> DeepLinkHandlingResult {
        var disposedHandlerIndices: [Int] = []
        
        var rawValueWasHandled = false
        
        for (index, handler) in handlers.enumerated() {
            switch handler.attemptHandle(rawValue: rawValue) {
            case .handled:
                rawValueWasHandled = true
                
            case .notHandled(let error):
                if
                    let handlerBoxError = error as? Errors,
                    case .handlerDisposed = handlerBoxError
                {
                    disposedHandlerIndices.append(index)
                }

            case .partiallyHandled:
                // Нужно чтобы какой-то хендлер для таких случаев
                // обязательно возвращал handled + соблюсти последовательность вызов
                break
            }
        }
        
        for index in disposedHandlerIndices.reversed() {
            handlers.remove(at: index)
        }
        
        if rawValueWasHandled {
            return .success
        }
        else {
            rawValueQueue.append(rawValue)
            return .enqueued
        }
    }
    
    private mutating func attemptToHandleQueuedRawValues(
        with handler: some RawValueHandlerProtocol<RawValue>
    ) {
        var rawValuesToRemove: Set<RawValue> = []
        
        for rawValue in rawValueQueue {
            if case .handled = handler.attemptHandle(rawValue: rawValue) {
                rawValuesToRemove.insert(rawValue)
            }
        }
        
        rawValueQueue = rawValueQueue.filter { !rawValuesToRemove.contains($0) }
    }
}

private extension DeepLinkServiceState {
    final class WeakHandler: RawValueHandlerProtocol {
        private let state: State
        
        init(_ handler: some RawValueHandlerProtocol<RawValue>) {
            state = .init(handlerRef: handler)
        }
        
        func attemptHandle(rawValue: RawValue) -> HandlingResult {
            guard let handler = state.handlerRef else {
                return .notHandled(Errors.handlerDisposed)
            }
            
            return handler.attemptHandle(rawValue: rawValue)
        }
        
        private struct State {
            weak var handlerRef: (any RawValueHandlerProtocol<RawValue>)?
        }
    }

    enum Errors: Error {
        case handlerDisposed
    }
}
