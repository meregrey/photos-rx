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
    
    private let diskCache = DiskCache.shared
    private let memoryCache = ImageCache()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    
    private init() {}
    
    func loadImages(from urls: [URL]) -> Observable<UIImage> {
        return Observable.from(urls)
            .filter(notExists)
            .flatMap(loadImage)
    }
    
    func image(from url: URL) -> UIImage? {
        if let memoryCachedImage = memoryCache.image(for: url) { return memoryCachedImage }
        
        if let diskCachedData = diskCache.data(named: url.imageName), let diskCachedImage = UIImage(data: diskCachedData)?.scaledToScreenWidth() {
            memoryCache.store(diskCachedImage, for: url)
            return diskCachedImage
        }
        
        return nil
    }
    
    func clearCache() {
        diskCache.clear()
    }
    
    private func notExists(for url: URL) -> Bool {
        return memoryCache.image(for: url) == nil && diskCache.exists(named: url.imageName) == false
    }
    
    private func loadImage(from url: URL) -> Observable<UIImage> {
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .map {
                guard let image = UIImage(data: $0)?.scaledToScreenWidth() else { throw LoadingError.invalidData }
                guard let data = image.pngData() else { throw LoadingError.failedToGenerateData }
                self.diskCache.store(data, named: url.imageName)
                self.memoryCache.store(image, for: url)
                return image
            }
            .subscribe(on: backgroundScheduler)
    }
}
