import AVFoundation

#if os(iOS)
@MainActor
final class AudioSessionManager: AudioSessionManaging {
    // MARK: - Private properties

    private let session: AVAudioSession

    // MARK: - Lifecycle

    init(session: AVAudioSession = .sharedInstance()) {
        self.session = session
    }

    // MARK: - Public methods

    func activateForPlayback() throws {
        try session.setCategory(.playback, mode: .spokenAudio)
        try session.setActive(true)
    }

    func activateForRecording() throws {
        try session.setCategory(
            .playAndRecord,
            mode: .spokenAudio,
            options: [.defaultToSpeaker, .allowBluetoothHFP]
        )
        try session.setActive(true)
    }
}
#endif
