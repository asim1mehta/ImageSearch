//
//  LocalDataStoreTests.swift
//  Image ListTests
//
//  Created by Asim on 15/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import XCTest
@testable import Image_List

class LocalDataStoreTests: XCTestCase {
    
    let keyForStoring = "testKey"
    
    override func setUp() {
        super.setUp()
        
        LocalDataStore.testable_setFileManager(FileManager.default)
    }
    
    override func tearDown() {
        super.tearDown()
        
        if let cacheDirectoryPath = LocalDataStore.generateCacheDirectoryPathFor(key: keyForStoring) {
            try? FileManager.default.removeItem(at: cacheDirectoryPath)
        }
    }

    func testStorage() throws {
        let valueToBeStored = "test123"
        
        LocalDataStore.store(value: valueToBeStored, forKey: keyForStoring)
        let valueFetched: String? = LocalDataStore.object(forKey: keyForStoring)
        
        XCTAssertEqual(valueToBeStored, valueFetched)
    }
    
    func testRemovingStorage() {
        let valueToBeStored = "1234"
        
        LocalDataStore.store(value: valueToBeStored, forKey: keyForStoring)
        LocalDataStore.removeObject(forKey: keyForStoring)
        
        if let url = LocalDataStore.generateCacheDirectoryPathFor(key: keyForStoring) {
            let doesFileExists = FileManager.default.fileExists(atPath: url.path)
            XCTAssertFalse(doesFileExists)
        } else {
            XCTFail()
        }
    }
    
}
