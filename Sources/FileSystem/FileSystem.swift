import Foundation

public final class FileSystem: FileSystemProtocol {
    // MARK: - Private properties

    private let fileManager: FileManager

    // MARK: - Public properties

    public var temporaryDirectory: URL {
        fileManager.temporaryDirectory
    }

    public var cachesDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    }

    // MARK: - Lifecycle

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public methods

    public func fileURL(in directoryURL: URL, named fileName: String) -> URL {
        directoryURL.appendingPathComponent(fileName)
    }

    public func directoryURL(in parentDirectoryURL: URL, named directoryName: String) -> URL {
        parentDirectoryURL.appendingPathComponent(directoryName, isDirectory: true)
    }

    public func temporaryFileURL(prefix: String, pathExtension: String? = nil) -> URL {
        var url = fileURL(in: temporaryDirectory, named: "\(prefix)-\(UUID().uuidString)")

        if let pathExtension {
            url.appendPathExtension(pathExtension)
        }

        return url
    }

    public func writeTemporaryFile(
        _ data: Data,
        prefix: String,
        pathExtension: String? = nil
    ) throws -> URL {
        let url = temporaryFileURL(prefix: prefix, pathExtension: pathExtension)
        try data.write(to: url, options: .atomic)
        return url
    }

    public func fileExists(at url: URL) -> Bool {
        fileManager.fileExists(atPath: url.path)
    }

    public func removeItem(at url: URL) throws {
        try fileManager.removeItem(at: url)
    }

    public func removeItemIfExists(at url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) else {
            return
        }

        try fileManager.removeItem(at: url)
    }

    public func createDirectory(at url: URL, withIntermediateDirectories: Bool = true) throws {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories)
    }

    public func moveItem(at sourceURL: URL, to destinationURL: URL) throws {
        try fileManager.moveItem(at: sourceURL, to: destinationURL)
    }
}
