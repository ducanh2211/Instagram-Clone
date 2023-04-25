//
//  PhotoSelectorCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/04/2023.
//

import UIKit
import Photos

class PhotoSelectorCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  var assetQueue: DispatchQueue!
  
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
  }
  
  func configure(withImage image: UIImage) {
    photoImageView.image = image
  }
  
  func configure(withAsset asset: PHAsset) {
    let options = PHImageRequestOptions()
    let targetSize = CGSize(width: bounds.size.width * 4, height: bounds.size.height * 4)
    
    asset.getImageFromAsset(targetSize: targetSize, options: options, queue: assetQueue) { image in
      if let image = image {
        DispatchQueue.main.async {
          self.photoImageView.image = image
          print("cell image size: \(image.size)")
        }
      }
    }
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
