//
//  MockImageLoader.swift
//  PhotosTests
//
//  Created by Yeojin Yoon on 2022/08/19.
//

@testable import Photos
import Foundation
import RxSwift

struct MockImageLoader: ImageLoadable {
    func loadImages(from urls: [URL]) -> Observable<UIImage> {
        return Observable.just(UIImage())
    }
    
    func image(from url: URL) -> UIImage? {
        return nil
    }
    
    func clearCache() {}
}
