//
//  PhotoListTableViewCell.swift
//  Photos
//
//  Created by Yeojin Yoon on 2022/08/04.
//

import RxCocoa
import RxSwift
import UIKit

final class PhotoListTableViewCell: UITableViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        userNameLabel.text = nil
    }
    
    func configure(with viewModel: PhotoViewModel) {
        photoImageView.image = viewModel.image
        userNameLabel.text = viewModel.userName
    }
}
