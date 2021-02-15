//
//  NextPageFetchable.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

/// NextPageFetchable: Provides a blueprint for implementing Pagination functionality
protocol NextPageFetchable {
    var isFetchingListDataInProgress: Bool { get }
    
    func isMoreDataAvailableForFetching(currentDataSize: Int) -> Bool
    func canFetchNextPage(currentDataSize: Int) -> Bool
}

extension NextPageFetchable {
    func canFetchNextPage(currentDataSize: Int) -> Bool {
        return isMoreDataAvailableForFetching(currentDataSize: currentDataSize) && !isFetchingListDataInProgress
    }
}
