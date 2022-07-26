//
//  BaseRouter.swift
//  MynaLabsTask
//
//  Created by Roman Rakhlin on 7/25/22.
//

import Foundation

struct HttpHeader {
    var field: String
    var value: String
}

protocol BaseRouter {
    var path: String { get }
    var method: HttpMethod { get }
    var httpBody: Data? { get }
    var httpHeader: [HttpHeader]? { get }
}

extension BaseRouter {

    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.giphy.com"
    }
    
    var apiKey: String {
        return "jkm03kNosnH8AfYEZxNk6EBZzUt6c6D7"
    }

    func createURLRequest(offset: Int) -> URLRequest {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(20)")
        ]

        
        guard let url = urlComponents.url else {
            fatalError(URLError(.unsupportedURL).localizedDescription)
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBody
        
        httpHeader?.forEach { (header) in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.field)
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }
}
