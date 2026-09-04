#if os(iOS)
@MainActor
protocol AudioSessionManaging: AnyObject {
    func activateForPlayback() throws
    func activateForRecording() throws
}
#endif
