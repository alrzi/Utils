import FileSystem

#if os(iOS)
@MainActor
public enum AudioServicesFactory {
    // MARK: - Public methods

    public static func make(fileSystem: any FileSystemProtocol) -> AudioServices {
        let audioSessionManager = AudioSessionManager()

        return AudioServices(
            recordingService: AudioRecordingService(
                fileSystem: fileSystem,
                audioSessionManager: audioSessionManager
            ),
            playbackService: AudioPlaybackService(audioSessionManager: audioSessionManager)
        )
    }
}
#endif
