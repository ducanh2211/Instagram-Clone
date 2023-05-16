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
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 64 / 2
    imageView.backgroundColor = .systemPink
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "My story"
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.numberOfLines = 1
    label.textAlignment = .center
    return label
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
    contentView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      photoImageView.widthAnchor.constraint(equalToConstant: 64),
      photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor),
      
      titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 3),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
      titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    ])
  }
  
}
