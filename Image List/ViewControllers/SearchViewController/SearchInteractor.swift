//
//  SearchInteractor.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

class SearchInteractor {
    private var searchTask: CancelableTask?
    
    private var page = 1
    private var currentQuery: SearchQuery!
    private var totalResultsAvailabeleForCurrentQuery: Int?
    
    func performNewSearchFor(query: SearchQuery, completion: @escaping ([SearchResult], String?) -> Void) {
        page = 1
        currentQuery = query
        totalResultsAvailabeleForCurrentQuery = nil
        
        let request = Image.FetchingRequest(query: query.keyword, page: page)
        
        performSearch(request: request, completion: completion)
    }
    
    func cancelLastSearch() {
        searchTask?.cancel()
        searchTask = nil
    }
    
    private func performSearch(request: Image.FetchingRequest, completion: @escaping ([SearchResult], String?) -> Void) {
        searchTask?.cancel()
        searchTask = Image.fetchWith(request: request) { [weak self] (response) in
            guard response.isSuccessful else {
                completion([], response.errorMessage)
                return
            }
            
            self?.totalResultsAvailabeleForCurrentQuery = response.total
            
            if response.images.count > 0, let weakSelf = self {
                RecentSearchStore.addNew(searchQuery: weakSelf.currentQuery)
                completion(response.images, nil)
            } else {
                completion([], "Unable to find results for your query")
            }
            
        }
    }
}
