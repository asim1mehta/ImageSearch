//
//  Image+DataFetching.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

extension Image {
    
    static func fetchWith(request: FetchingRequest, completion: (ImageFetchResponse) -> Void) {
        
    }

    // MARK: - Server Response
    fileprivate struct ImageFetchServerResponse: Codable {
        let total, totalHits: Int
        let hits: [Image]
    }
    
    struct ImageFetchResponse {
        let total: Int
        let totalHits: Int
        let images: [Image]
        let isSuccessful: Bool
        let errorMessage: String?
    }

    
    // MARK: Fetching request
    struct FetchingRequest {
        let query: String
        let page: Int
    }
}
