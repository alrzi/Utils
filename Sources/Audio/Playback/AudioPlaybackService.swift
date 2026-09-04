import AVFoundation
import Combine
import Foundation

#if os(iOS)
@MainActor
final class AudioPlaybackService: NSObject, AudioPlaybackServiceProtocol {
    // MARK: - Private properties

    private let audioSessionManager: any AudioSessionManaging
    private let stateSubject = CurrentValueSubject<AudioPlaybackState, Never>(.idle)
    private let progressSubject = CurrentValueSubject<TimeInterval, Never>(0)

    private var player: AVAudioPlayer?
    private var progressTimer: Timer?
    private var currentURL: URL?

    // MARK: - Lifecycle

    init(audioSessionManager: any AudioSessionManaging) {
        self.audioSessionManager = audioSessionManager
    }

    // MARK: - Public properties

    var statePublisher: AnyPublisher<AudioPlaybackState, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    var progressPublisher: AnyPublisher<TimeInterval, Never> {
        progressSubject.eraseToAnyPublisher()
    }

    // MARK: - Public methods

    func play(url: URL) {
        do {
            try audioSessionManager.activateForPlayback()

            if currentURL != url {
                stop()
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                currentURL = url
            }
        } catch {
            stateSubject.send(.failed(error.localizedDescription))
            return
        }

        guard player?.play() == true else {
            stateSubject.send(.failed("Unable to start audio playback"))
            return
        }

        installProgressTimerIfNeeded()
        stateSubject.send(.playing(url))
    }

    func pause() {
        guard let url = currentURL else {
            return
        }

        player?.pause()
        progressTimer?.invalidate()
        progressTimer = nil
        stateSubject.send(.paused(url))
    }

    func stop() {
        player?.pause()
        player?.currentTime = 0
        progressTimer?.invalidate()
        progressTimer = nil
        player = nil
        progressSubject.send(0)
        stateSubject.send(.idle)
        currentURL = nil
    }

    // MARK: - Private methods

    private func installProgressTimerIfNeeded() {
        guard progressTimer == nil else {
            return
        }

        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else {
                    return
                }

                self.progressSubject.send(self.player?.currentTime ?? 0)

                if let player = self.player,
                   player.currentTime >= player.duration,
                   player.duration > 0 {
                    self.stop()
                }
            }
        }
    }
}
#endif
