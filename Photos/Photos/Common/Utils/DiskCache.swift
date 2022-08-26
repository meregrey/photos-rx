//
//  DiskCache.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/23.
//

import Foundation

final class DiskCache {
    static let shared = DiskCache(fileManager: FileManager.default, directoryName: Bundle.main.bundleIdentifier ?? "")
    
    private let fileManager: FileManager
    private let directoryName: String
    
    private var directoryPath: String { fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(directoryName).relativePath ?? "" }
    
    init(fileManager: FileManager, directoryName: String) {
        self.fileManager = fileManager
        self.directoryName = directoryName
    }
    
    func createDirectoryIfNeeded() {
        if fileManager.fileExists(atPath: directoryPath) { return }
        try? fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
    }
    
    func exists(named name: String) -> Bool {
        let enumerator = fileManager.enumerator(atPath: directoryPath)
        let files = enumerator?.allObjects as? [String] ?? []
        return files.filter({ $0.contains(name) }).count > 0
    }
    
    func store(_ data: Data, named name: String) {
        let url = URL(fileURLWithPath: directoryPath).appendingPathComponent(name)
        try? data.write(to: url)
    }
    
    func data(named name: String) -> Data? {
        let path = directoryPath + "/" + name
        return fileManager.contents(atPath: path)
    }
    
    func clear() {
        try? fileManager.removeItem(atPath: directoryPath)
        createDirectoryIfNeeded()
    }
}
