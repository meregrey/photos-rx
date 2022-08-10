//
//  APIKind.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import Foundation

enum APIKind {
    case searchPhotos(query: String)
    
    var path: String {
        switch self {
        case .searchPhotos:
            return "search/photos"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchPhotos(let query):
            return [URLQueryItem(name: "query", value: query)]
        }
    }
}
