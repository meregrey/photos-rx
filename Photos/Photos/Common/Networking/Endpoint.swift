//
//  Endpoint.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import Foundation

struct Endpoint {
    private let scheme = "https"
    private let host = "api.unsplash.com"
    private let headerField = "Authorization"
    private let headerValue = "Client-ID \(Authentication.accessKey)"
    private let apiKind: APIKind
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/" + apiKind.path
        components.queryItems = apiKind.queryItems
        return components.url
    }
    
    init(for apiKind: APIKind) {
        self.apiKind = apiKind
    }
    
    func makeRequest() -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.setValue(headerValue, forHTTPHeaderField: headerField)
        return request
    }
}
