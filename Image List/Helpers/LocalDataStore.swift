//
//  LocalDataStore.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

///LocalDataStore: Stores Data in Cache Directory corresponding to Key provided
class LocalDataStore {
    private static let jsonEncoder = JSONEncoder()
    private static let jsonDecoder = JSONDecoder()
    
    private static var fileManager = FileManager.default
        
    static func store<T: Codable>(value: T, forKey key: String) {
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
    
    static func removeObject(forKey key: String) {
        guard let cacheDirectoryURL = generateCacheDirectoryPathFor(key: key),
            fileManager.fileExists(atPath: cacheDirectoryURL.path) else {
                return
        }
        
        do {
            try fileManager.removeItem(at: cacheDirectoryURL)
        } catch {
            print("Failed to remove data: \(error.localizedDescription)")
        }
    }
    
    static func generateCacheDirectoryPathFor(key: String) -> URL? {
        guard let cacheDirectoryUrl = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let filePath = cacheDirectoryUrl.appendingPathComponent(key)
        return filePath
    }
    
    // MARK: - Testable
    static func testable_setFileManager(_ fileManager: FileManager) {
        Self.fileManager = fileManager
    }
}
