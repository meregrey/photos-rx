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
    let shouldLoadMorePhotos = BehaviorRelay<Bool>(value: false)
    let photos = BehaviorRelay<[PhotoViewModel]>(value: [])
    
    private let photoViewModels = PublishRelay<[PhotoViewModel]>()
    private let api: APIType
    private let imageLoader: ImageLoadable
    
    private var page = 0
    private var disposeBag = DisposeBag()
    
    init(api: APIType = API.shared, imageLoader: ImageLoadable = ImageLoader.shared) {
        self.api = api
        self.imageLoader = imageLoader
        
        searchTerm
            .distinctUntilChanged()
            .flatMap(searchPhotos)
            .flatMap(transform)
            .bind(to: photos)
            .disposed(by: disposeBag)
        
        shouldLoadMorePhotos
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: loadMorePhotos)
            .disposed(by: disposeBag)
    }
    
    private func searchPhotos(for searchTerm: String) -> Observable<[Photo]> {
        page = 1
        return api.searchPhotos(query: searchTerm, page: page)
    }
    
    private func transform(_ photos: [Photo]) -> Observable<[PhotoViewModel]> {
        let urls = photos.compactMap { $0.url }
        
        _ = imageLoader.loadImages(from: urls)
            .subscribe(onCompleted: {
                if photos.count > 0 {
                    var photoViewModels = self.photos.value
                    photoViewModels.append(contentsOf: photos.map(PhotoViewModel.init))
                    self.photoViewModels.accept(photoViewModels)
                } else {
                    self.photoViewModels.accept([])
                }
            })
        
        return photoViewModels.asObservable()
    }
    
    private func loadMorePhotos(_: Bool) {
        page += 1
        
        api.searchPhotos(query: searchTerm.value, page: page)
            .flatMap(transform)
            .bind(to: photos)
            .disposed(by: disposeBag)
    }
}
