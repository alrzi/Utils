@MainActor
public struct AudioServices {
    // MARK: - Public properties

    public let recordingService: any AudioRecordingServiceProtocol
    public let playbackService: any AudioPlaybackServiceProtocol

    // MARK: - Lifecycle

    init(
        recordingService: any AudioRecordingServiceProtocol,
        playbackService: any AudioPlaybackServiceProtocol
    ) {
        self.recordingService = recordingService
        self.playbackService = playbackService
    }
}
