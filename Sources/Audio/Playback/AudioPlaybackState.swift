import Foundation

public enum AudioPlaybackState: Sendable, Equatable {
    case idle
    case playing(URL)
    case paused(URL)
    case failed(String)
}
