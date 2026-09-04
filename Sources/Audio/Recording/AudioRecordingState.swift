import Foundation

public enum AudioRecordingState: Sendable, Equatable {
    case idle
    case requestingPermission
    case recording
    case finishing
    case failed(String)
}
