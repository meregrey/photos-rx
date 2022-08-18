//
//  DetailViewController.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/18.
//

import UIKit

final class DetailViewController: UIViewController {
    var viewModel: PhotoViewModel!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        navigationItem.largeTitleDisplayMode = .never
        title = viewModel.userName()
        imageView.image = viewModel.image()
    }
}
