//
//  ImageCache.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import UIKit

struct ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    func store(_ image: UIImage, for url: URL) {
        guard let key = NSURL(string: url.absoluteString) else { return }
        cache.setObject(image, forKey: key)
    }
    
    func image(for url: URL) -> UIImage? {
        guard let key = NSURL(string: url.absoluteString) else { return nil }
        return cache.object(forKey: key)
    }
}
