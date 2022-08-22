//
//  MockAPI.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/08/19.
//

@testable import Photos
import Foundation
import RxSwift

struct MockAPI: APIType {
    func searchPhotos(query: String, page: Int) -> Observable<[Photo]> {
        guard let url = Bundle.main.url(forResource: "MockData\(page)", withExtension: "json") else { return Observable.just([]) }
        guard let data = try? Data(contentsOf: url) else { return Observable.just([]) }
        guard let searchResponse = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return Observable.just([]) }
        return Observable.just(searchResponse.results)
    }
}
