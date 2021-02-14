//
//  SearchInteractor.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

class SearchInteractor: NextPageFetchable {
    
    // MARK: - Properties
    ///Latest Search Results Fetching Task
    private var searchTask: CancelableTask?
    
    private var page = 1
    private var currentQuery: SearchQuery!
    private var totalResultsAvailabeleForCurrentQuery: Int?
    
    private(set) var isFetchingListDataInProgress: Bool = false
    
    // MARK: - Methods
    func performNewSearchFor(query: SearchQuery, completion: @escaping ([SearchResult], String?) -> Void) {
        page = 1
        currentQuery = query
        totalResultsAvailabeleForCurrentQuery = nil
        
        let request = Image.FetchingRequest(query: query.keyword, page: page)
        
        performSearch(request: request, completion: completion)
    }
    
    func fetchNextPage(completion: @escaping ([SearchResult], String?) -> Void ) {
        let request = Image.FetchingRequest(query: currentQuery.keyword, page: page + 1)
        
        performSearch(request: request) { [weak self] (result, errorMessage) in
            if errorMessage == nil {
                self?.page += 1
            }
            completion(result, errorMessage)
        }
    }
    
    func isMoreDataAvailableForFetching(currentDataSize: Int) -> Bool {
        guard let total = totalResultsAvailabeleForCurrentQuery else {
            return false
        }
        
        return total > currentDataSize
    }
    
    func cancelLastSearch() {
        searchTask?.cancel()
        searchTask = nil
    }
    
    // MARK: - Private Methods
    private func performSearch(request: Image.FetchingRequest, completion: @escaping ([SearchResult], String?) -> Void) {
        searchTask?.cancel()
        
        isFetchingListDataInProgress = true
        
        searchTask = Image.fetchWith(request: request) { [weak self] (response) in
            self?.isFetchingListDataInProgress = false
            
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
