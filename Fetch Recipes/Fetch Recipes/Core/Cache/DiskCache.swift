//
//  DiskCache.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import Foundation

actor DiskCache {
    // MARK: - Properties
    static let shared = DiskCache()
    private let fileManager = FileManager.default
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?
            .appendingPathComponent("ImageCache")
    }
    
    // MARK: - Initialization
    private init() {
        Task {
            await createCacheDirectoryIfNeeded()
        }
    }
    
    // MARK: - Private Methods
    // Ensures the cache directory exists before saving or retrieving files.
    private func createCacheDirectoryIfNeeded() {
        guard let cacheDirectory else { return }
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(
                at: cacheDirectory,
                withIntermediateDirectories: true
            )
        }
    }
    
    // Generates a file path for the given key.
    private func cacheFileURL(for key: String) -> URL? {
        cacheDirectory?.appendingPathComponent(key)
    }
    
    // MARK: - Public Methods
    // Saves data to disk using the given key.
    func save(_ data: Data, for key: String) async throws {
        guard let fileURL = cacheFileURL(for: key) else {
            throw CacheError.invalidKey(key: key)
        }
        
        try data.write(to: fileURL)
    }
    
    // Retrieves data from disk for the given key.
    func retrieve(for key: String) async throws -> Data {
        guard let fileURL = cacheFileURL(for: key),
              fileManager.fileExists(atPath: fileURL.path) else {
            throw CacheError.notFound
        }
        
        return try Data(contentsOf: fileURL)
    }
    
    // Removes a specific file from the cache.
    func remove(for key: String) async throws {
        guard let fileURL = cacheFileURL(for: key),
              fileManager.fileExists(atPath: fileURL.path) else {
            throw CacheError.notFound
        }
        
        try fileManager.removeItem(at: fileURL)
    }
    
    // Clears all files in the cache.
    func removeAll() async throws {
        guard let cacheDirectory else {
            throw CacheError.directoryNotFound
        }
        
        try fileManager.removeItem(at: cacheDirectory)
        createCacheDirectoryIfNeeded()
    }
}

// MARK: - CacheError
enum CacheError: Error {
    case directoryNotFound
    case invalidKey(key: String)
    case notFound
}
