//
//  PhotoCollectionViewCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 06/05/2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { String(describing: self) }

    private let photoImageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
        photoImageView.pinToView(contentView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with imageString: String) {
        photoImageView.sd_setImage(with: URL(string: imageString))
    }
}
