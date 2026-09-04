import Foundation

public struct RecordedAudio: Sendable {
    // MARK: - Public properties

    public let url: URL
    public let duration: TimeInterval

    // MARK: - Lifecycle

    public init(url: URL, duration: TimeInterval) {
        self.url = url
        self.duration = duration
    }
}
