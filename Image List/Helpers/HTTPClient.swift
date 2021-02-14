//
//  HTTPClient.swift
//  Image List
//
//  Created by Asim on 14/02/21.
//  Copyright © 2021 Asim. All rights reserved.
//

import Foundation

class HTTPClient {
    
    private static let timeoutInterval: TimeInterval = 30
    
    @discardableResult
    class func request<T: Codable>(_ request: Request, completion: @escaping (Response<T>) -> Void) -> URLSessionDataTask? {
        guard let urlRequest = createURLRequestFrom(request: request) else {
            return nil
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, let unwrappedData = data else {
                let serverResponse = Response<T>(data: nil, errorMessage: error?.localizedDescription, status: (response as? HTTPURLResponse)?.statusCode ?? 400)
                DispatchQueue.main.async {
                    completion(serverResponse)
                }
                return
            }
            
            do {
                let decodedData = try newJSONDecoder().decode(T.self, from: unwrappedData)
                let serverResponse = Response(data: decodedData, errorMessage: error?.localizedDescription, status: httpResponse.statusCode)
                DispatchQueue.main.async {
                    completion(serverResponse)
                }
            } catch {
                print(error.localizedDescription)
            }
            
        }
        dataTask.resume()
        
        return dataTask
    }
    
    private static func createURLRequestFrom(request: Request) -> URLRequest? {
        guard let url = URL(string: request.urlString) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }
    
    private static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
}

extension HTTPClient {
    struct Request {
        let method: Method
        let urlString: String
    }
    
    struct Response<T: Codable> {
        let data: T?
        let errorMessage: String?
        let status: Int
    }
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}

