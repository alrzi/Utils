import Foundation

public protocol FileSystemProtocol: AnyObject {
    var temporaryDirectory: URL { get }
    var cachesDirectory: URL? { get }

    func fileURL(in directoryURL: URL, named fileName: String) -> URL
    func directoryURL(in parentDirectoryURL: URL, named directoryName: String) -> URL
    func temporaryFileURL(prefix: String, pathExtension: String?) -> URL
    func writeTemporaryFile(_ data: Data, prefix: String, pathExtension: String?) throws -> URL
    func fileExists(at url: URL) -> Bool
    func removeItem(at url: URL) throws
    func removeItemIfExists(at url: URL) throws
    func createDirectory(at url: URL, withIntermediateDirectories: Bool) throws
    func moveItem(at sourceURL: URL, to destinationURL: URL) throws
}
