//
//  PhotoViewModel.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import RxSwift
import UIKit

final class PhotoViewModel {
    private let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func image() -> UIImage? {
        guard let url = photo.url else { return nil }
        return ImageLoader.shared.image(from: url)
    }
    
    func userName() -> String {
        return photo.userName
    }
}
