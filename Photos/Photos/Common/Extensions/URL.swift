//
//  URL.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/24.
//

import Foundation

extension URL {
    var imageName: String { "\(lastPathComponent).png" }
}
