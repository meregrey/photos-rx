//
//  ImageLoader.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import RxSwift
import UIKit

final class ImageLoader: ImageLoadable {
    static let shared = ImageLoader()
    
    private let cache = ImageCache()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    private init() {}
    
    func loadImages(from urls: [URL]) -> Observable<UIImage> {
        return Observable.from(urls)
            .filter { self.cache.image(for: $0) == nil }
            .flatMap(loadImage)
    }
    
    func image(from url: URL) -> UIImage? {
        return cache.image(for: url)
    }
    
    private func loadImage(from url: URL) -> Observable<UIImage> {
        return Observable.just(url)
            .observe(on: backgroundScheduler)
            .flatMap {
                URLSession.shared.rx.data(request: URLRequest(url: $0))
                    .map {
                        guard let image = UIImage(data: $0)?.scaledToScreenWidth() else { throw LoadingError.invalidImageData }
                        self.cache.save(image, for: url)
                        return image
                    }
            }
    }
}
