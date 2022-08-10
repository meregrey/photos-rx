//
//  UIImage.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import UIKit

extension UIImage {
    func scaledToScreenWidth() -> UIImage {
        let screenWidth = UIScreen.main.bounds.width
        let imageWidth = size.width
        let imageHeight = size.height
        let scaledHeight = screenWidth * imageHeight / imageWidth
        let scaledSize = CGSize(width: screenWidth, height: scaledHeight)
        let image = UIGraphicsImageRenderer(size: scaledSize).image { _ in
            draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        return image.withRenderingMode(renderingMode)
    }
}
