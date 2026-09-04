import AVFoundation
import Combine
import FileSystem
import Foundation

#if os(iOS)
@MainActor
final class AudioRecordingService: NSObject, AudioRecordingServiceProtocol {
    // MARK: - Private properties

    private let fileSystem: any FileSystemProtocol
    private let audioSessionManager: any AudioSessionManaging
    private let stateSubject = CurrentValueSubject<AudioRecordingState, Never>(.idle)
    private let durationSubject = CurrentValueSubject<TimeInterval, Never>(0)

    private var recorder: AVAudioRecorder?
    private var timerCancellable: AnyCancellable?
    private var currentRecordingURL: URL?

    // MARK: - Lifecycle

    init(
        fileSystem: any FileSystemProtocol,
        audioSessionManager: any AudioSessionManaging
    ) {
        self.fileSystem = fileSystem
        self.audioSessionManager = audioSessionManager
    }

    // MARK: - Public properties

    var statePublisher: AnyPublisher<AudioRecordingState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    var durationPublisher: AnyPublisher<TimeInterval, Never> {
        durationSubject.eraseToAnyPublisher()
    }

    // MARK: - Public methods

    func start() {
        Task { @MainActor [weak self] in
            guard let self else {
                return
            }

            await requestPermissionAndStartRecording()
        }
    }

    func stop() -> AnyPublisher<RecordedAudio, Error> {
        guard let recorder, recorder.isRecording, let url = currentRecordingURL else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        stateSubject.send(.finishing)

        let recordedAudio = RecordedAudio(url: url, duration: recorder.currentTime)
        recorder.stop()
        finishTimer()
        self.recorder = nil
        currentRecordingURL = nil
        stateSubject.send(.idle)

        return Just(recordedAudio)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func cancel() {
        recorder?.stop()
        recorder?.deleteRecording()
        recorder = nil

        if let currentRecordingURL {
            try? fileSystem.removeItem(at: currentRecordingURL)
        }

        currentRecordingURL = nil
        finishTimer()
        durationSubject.send(0)
        stateSubject.send(.idle)
    }

    // MARK: - Private methods

    private func beginRecording() {
        do {
            try audioSessionManager.activateForRecording()

            let url = fileSystem.temporaryFileURL(prefix: "voice-note", pathExtension: "m4a")
            let settings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44_100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
            ]
            let recorder = try AVAudioRecorder(url: url, settings: settings)

            recorder.isMeteringEnabled = true
            recorder.record()

            self.recorder = recorder
            currentRecordingURL = url
            durationSubject.send(0)
            stateSubject.send(.recording)
            startTimer()
        } catch {
            stateSubject.send(.failed(error.localizedDescription))
        }
    }

    private func requestPermissionAndStartRecording() async {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            beginRecording()

        case .denied:
            stateSubject.send(.failed("Microphone access is denied."))

        case .undetermined:
            stateSubject.send(.requestingPermission)

            let granted = await withCheckedContinuation { continuation in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }

            if granted {
                beginRecording()
            } else {
                stateSubject.send(.failed("Microphone permission was not granted."))
            }

        @unknown default:
            stateSubject.send(.failed("Unsupported microphone permission state."))
        }
    }

    private func startTimer() {
        timerCancellable = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self, let recorder = self.recorder, recorder.isRecording else {
                    return
                }

                self.durationSubject.send(recorder.currentTime)
            }
    }

    private func finishTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
#endif
