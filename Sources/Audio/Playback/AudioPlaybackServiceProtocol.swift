import Combine
import Foundation

@MainActor
public protocol AudioPlaybackServiceProtocol: AnyObject {
    var statePublisher: AnyPublisher<AudioPlaybackState, Never> { get }
    var progressPublisher: AnyPublisher<TimeInterval, Never> { get }

    func play(url: URL)
    func pause()
    func stop()
}
