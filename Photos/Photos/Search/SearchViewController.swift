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
        bindViewModel()
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
    }
    
    private func bindViewModel() {
        searchController.searchBar.rx.text.orEmpty
            .asDriver()
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .drive(viewModel.searchTerm)
            .disposed(by: disposeBag)
        
        viewModel.photos
            .asDriver()
            .drive(photoListTableView.rx.items(cellIdentifier: PhotoListTableViewCell.identifier, cellType: PhotoListTableViewCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel)
            }
            .disposed(by: disposeBag)
    }
}
