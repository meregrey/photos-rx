//
//  API.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import Foundation
import RxSwift

final class API: APIType {
    static let shared = API()
    
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    private init() {}
    
    func searchPhotos(query: String) -> Observable<[Photo]> {
        guard let request = Endpoint(for: .searchPhotos(query: query)).makeRequest() else { return Observable.just([]) }
        
        return URLSession.shared.rx.json(request: request)
            .observe(on: backgroundScheduler)
            .map(SearchResponse.transform)
    }
}
