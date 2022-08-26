//
//  ImageLoadable.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import Foundation
import RxSwift

protocol ImageLoadable {
    func loadImages(from urls: [URL]) -> Observable<UIImage>
    func image(from url: URL) -> UIImage?
    func clearCache()
}
