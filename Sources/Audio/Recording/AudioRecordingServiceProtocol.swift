import Combine
import Foundation

@MainActor
public protocol AudioRecordingServiceProtocol: AnyObject {
    var statePublisher: AnyPublisher<AudioRecordingState, Never> { get }
    var durationPublisher: AnyPublisher<TimeInterval, Never> { get }

    func start()
    func stop() -> AnyPublisher<RecordedAudio, Error>
    func cancel()
}
