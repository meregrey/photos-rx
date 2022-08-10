//
//  SearchResponse.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import Foundation

struct SearchResponse: Decodable {
    let results: [Photo]
    
    static func transform(_ json: Any) -> [Photo] {
        guard let data = try? JSONSerialization.data(withJSONObject: json) else { return [] }
        guard let searchResponse = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return [] }
        return searchResponse.results
    }
}
