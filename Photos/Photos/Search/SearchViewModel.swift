//
//  SearchViewModel.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/08.
//

import Foundation
import RxRelay
import RxSwift

final class SearchViewModel {
    let searchTerm = BehaviorRelay<String>(value: "")
    let photos = BehaviorRelay<[PhotoViewModel]>(value: [])
    
    private let relay = PublishRelay<[PhotoViewModel]>()
    
    private var disposeBag = DisposeBag()
    
    init(api: APIType = API.shared) {
        searchTerm
            .distinctUntilChanged()
            .flatMap(api.searchPhotos)
            .flatMap(transform)
            .bind(to: photos)
            .disposed(by: disposeBag)
    }
    
    private func transform(_ photos: [Photo]) -> Observable<[PhotoViewModel]> {
        let urls = photos.compactMap { $0.url }
        
        _ = ImageLoader.shared.loadImages(from: urls)
            .subscribe(onCompleted: {
                let photoViewModels = photos.map(PhotoViewModel.init)
                self.relay.accept(photoViewModels)
            })
        
        return relay.asObservable()
    }
}
