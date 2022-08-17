//
//  UIScrollView.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/14.
//

import UIKit

extension UIScrollView {
    func isNearBottom(offset: CGFloat = 300.0) -> Bool {
        return (self.contentOffset.y + self.frame.height + offset) > self.contentSize.height
    }
}
