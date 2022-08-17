//
//  SearchViewController.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import RxCocoa
import RxSwift
import UIKit

final class SearchViewController: UIViewController {
    private let searchController = UISearchController()
    private let viewModel = SearchViewModel()
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet private weak var photoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        bindInput()
        bindOutput()
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
    }
    
    private func bindInput() {
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)
        
        photoListTableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] _ in
                if let searchBar = self?.searchController.searchBar, searchBar.isFirstResponder {
                    searchBar.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        photoListTableView.rx.contentOffset
            .map(isNearBottom)
            .bind(to: viewModel.shouldLoadMorePhotos)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.photos
            .asDriver()
            .drive(photoListTableView.rx.items(cellIdentifier: PhotoListTableViewCell.identifier, cellType: PhotoListTableViewCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel)
            }
            .disposed(by: disposeBag)
    }
    
    private func isNearBottom(_: CGPoint) -> Bool {
        return photoListTableView.isNearBottom()
    }
}
