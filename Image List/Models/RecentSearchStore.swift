//
//  RecentSearches.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation


class RecentSearchStore {
    private static let maxCapacity = 10
    private static let storeKey = "com.imageList.searchQueries"
    
    private static var recentSearches: [SearchQuery] = {
        guard let searches: [SearchQuery] = LocalDataStore.object(forKey: storeKey) else {
            return []
        }
        return searches
    }()
    
    
    class func all() -> [SearchQuery] {
        return recentSearches
    }
    
    class func addNew(searchQuery: SearchQuery) {
        removeDuplicatesOf(query: searchQuery)
        
        if isAtMaxCapacity() {
            recentSearches.removeLast()
        }
        
        recentSearches.insert(searchQuery, at: 0)
        
        save()
    }
    
    private static func removeDuplicatesOf(query: SearchQuery) {
        recentSearches = recentSearches.filter {$0.keyword != query.keyword}
    }
    

    private static func isAtMaxCapacity() -> Bool {
        return recentSearches.count == maxCapacity
    }
    
    private static func save() {
        LocalDataStore.store(value: recentSearches, forKey: storeKey)
    }
}
