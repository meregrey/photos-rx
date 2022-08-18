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
        configureNavigationItem()
        bindInput()
        bindOutput()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { disposeBag = DisposeBag() }
    }
    
    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.backButtonTitle = ""
    }
    
    private func bindInput() {
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: viewModel.searchTerm)
            .disposed(by: disposeBag)
        
        photoListTableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                self.resignSearchBarStatus()
            })
            .disposed(by: disposeBag)
        
        photoListTableView.rx.contentOffset
            .map(isNearBottom)
            .bind(to: viewModel.shouldLoadMorePhotos)
            .disposed(by: disposeBag)
        
        photoListTableView.rx.modelSelected(PhotoViewModel.self)
            .asDriver()
            .drive(onNext: {
                self.showDetail(with: $0)
            })
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
    
    private func resignSearchBarStatus() {
        let searchBar = searchController.searchBar
        if searchBar.isFirstResponder { searchBar.resignFirstResponder() }
    }
    
    private func isNearBottom(_: CGPoint) -> Bool {
        return photoListTableView.isNearBottom()
    }
    
    private func showDetail(with viewModel: PhotoViewModel) {
        let storyboard = UIStoryboard(name: ResourceName.Storyboard.main, bundle: nil)
        guard let detailViewController = storyboard.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
        detailViewController.viewModel = viewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
