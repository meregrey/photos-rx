//
//  APIType.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import Foundation
import RxSwift

protocol APIType {
    func searchPhotos(query: String, page: Int) -> Observable<[Photo]>
}
