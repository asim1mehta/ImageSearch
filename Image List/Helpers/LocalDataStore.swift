//
//  LocalDataStore.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

class LocalDataStore {
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    
    static func store<T: Codable>(value: T?, forKey key: String) {
        guard let unwrappedValue = value else {
            removeObject(forKey: key)
            return
        }
        
        _store(value: unwrappedValue, forKey: key)
    }
    
    static func object<T: Codable>(forKey key: String) -> T? {
        guard let cacheDirectoryPath = generateCacheDirectoryPathFor(key: key) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: cacheDirectoryPath)
            let object = try jsonDecoder.decode(T.self, from: data)
            return object
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    
    private static func removeObject(forKey key: String) {
        guard let cacheDirectoryURL = generateCacheDirectoryPathFor(key: key),
            FileManager.default.fileExists(atPath: cacheDirectoryURL.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: cacheDirectoryURL)
        } catch {
            print("Failed to remove data: \(error.localizedDescription)")
        }
        
    }
    
    private static func _store<T: Codable>(value: T, forKey key: String) {
        guard let filePath = generateCacheDirectoryPathFor(key: key) else {
            return
        }
        do {
            let data = try jsonEncoder.encode(value)
            try data.write(to: filePath, options: [])
        } catch {
            print("Failed to store data: \(error.localizedDescription)")
        }
    }
    
    private static func generateCacheDirectoryPathFor(key: String) -> URL? {
        guard let cacheDirectoryUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let filePath = cacheDirectoryUrl.appendingPathComponent(key)
        return filePath
    }
}
