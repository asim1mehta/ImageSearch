//
//  Image+DataFetching.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

extension Image {
        
    @discardableResult
    static func fetchWith(request: FetchingRequest, completion: @escaping (ImageFetchResponse) -> Void) -> CancelableTask? {
        var params = request.getParams()
        params["key"] = Key.PixaBay.images
        
        let queryString = HTTPClient.queryString(from: params)
        
        let httpRequest = HTTPClient.Request(method: .get, urlString: ServerAPIs.pixabayBaseURL + "?" + queryString)
        let dataTask = HTTPClient.request(httpRequest) { (response: HTTPClient.Response<ImageFetchServerResponse>) in
            guard let data = response.data else {
                let failureResponse = ImageFetchResponse(total: 0, totalHits: 0, images: [], isSuccessful: false, errorMessage: response.errorMessage)
                completion(failureResponse)
                return
            }
            
            let imageFetchResponse = ImageFetchResponse(total: data.total , totalHits: data.totalHits, images: data.hits, isSuccessful: response.errorMessage == nil, errorMessage: response.errorMessage)
            completion(imageFetchResponse)
        }
        
        return dataTask
    }

    // MARK: - Server Response
    fileprivate struct ImageFetchServerResponse: Codable {
        let total, totalHits: Int
        let hits: [Image]
    }
    
    // MARK: - Fetch Response
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
        
        func getParams() -> [String: Any] {
            var params = [String: Any]()
            params["page"] = page
            params["q"] = query
            return params
        }
    }
}
