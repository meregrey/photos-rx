//
//  SearchViewModelTests.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/08/19.
//

@testable import Photos
import RxBlocking
import RxSwift
import RxTest
import XCTest

final class SearchViewModelTests: XCTestCase {
    var sut: SearchViewModel!
    var api: APIType!
    var imageLoader: ImageLoadable!
    var scheduler: ConcurrentDispatchQueueScheduler!
    
    override func setUp() {
        super.setUp()
        api = MockAPI()
        imageLoader = MockImageLoader()
        sut = SearchViewModel(api: api, imageLoader: imageLoader)
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    }
    
    override func tearDown() {
        sut = nil
        api = nil
        imageLoader = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testSearchPhotos() {
        // given
        let photos = sut.photos.asObservable().subscribe(on: scheduler)
        
        // when
        sut.searchTerm.accept("test")
        
        // then
        XCTAssertEqual(try photos.toBlocking().first()?.first?.userName, "name_1")
    }
    
    func testLoadMorePhotos() {
        // given
        let photos = sut.photos.asObservable().subscribe(on: scheduler)
        
        // when
        sut.searchTerm.accept("test")
        sut.shouldLoadMorePhotos.accept(true)
        
        // then
        XCTAssertEqual(try photos.toBlocking().first()?.first?.userName, "name_1")
        XCTAssertEqual(try photos.toBlocking().last()?.last?.userName, "name_2")
    }
}
