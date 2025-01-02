//
//  ImageCache.swift
//  Fetch Recipes
//
//  Created by Jasin ‎ on 12/11/24.
//

import Foundation
import UIKit
import CryptoKit

actor ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCache = DiskCache.shared
    
    private init() {
        memoryCache.countLimit = 100
    }
    
    private func hash(_ string: String) -> String {
        let inputData = Data(string.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func image(for url: URL) async throws -> UIImage {
        let key = hash(url.absoluteString)
        
        // Check memory cache first
        if let cached = memoryCache.object(forKey: key as NSString) {
//            print("🎯 Memory cache hit for: \(url)")
            return cached
        }
        
        // Check disk cache
        do {
            let data = try await diskCache.retrieve(for: key)
            if let image = UIImage(data: data) {
//                print("💾 Disk cache hit for: \(url)")
                memoryCache.setObject(image, forKey: key as NSString)
                return image
            } else {
                throw NSError(domain: "ImageCache", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
            }
        } catch CacheError.notFound {
            // Download and cache
//            print("⬇️ Downloading image for: \(url)")
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                // Save to both caches
                memoryCache.setObject(image, forKey: key as NSString)
                try await diskCache.save(data, for: key)
                return image
            } else {
                throw NSError(domain: "ImageCache", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode downloaded image data"])
            }
        }
    }
}
