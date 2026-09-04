
import Foundation

/// Обработчик «сырых» значений
public protocol RawValueHandlerProtocol<RawValue>: AnyObject, Sendable {
    associatedtype RawValue
    
    /// Попытается обработать «сырое» значение и вернет результат обработки
    ///
    /// - Parameters:
    ///   - rawValue: «сырое» значение, которое нужно обработать
    ///
    /// - Returns: результат обработки
    func attemptHandle(rawValue: RawValue) -> HandlingResult
}
