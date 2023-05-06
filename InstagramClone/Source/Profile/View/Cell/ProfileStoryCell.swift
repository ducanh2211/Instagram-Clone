//
//  ProfileStoryCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 06/05/2023.
//

import UIKit

class ProfileStoryCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  
  private let photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    contentView.addSubview(photoImageView)
    NSLayoutConstraint.activate([
      photoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      photoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
}
