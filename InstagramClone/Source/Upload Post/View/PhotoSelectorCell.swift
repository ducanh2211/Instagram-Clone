//
//  PhotoSelectorCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/04/2023.
//

import UIKit
import Photos

/// Đây là collection view cell sẽ có nhiệm vụ request và hiển thị UIImage từ PHAsset.
/// Nó sẽ cancel những request của các cell không hiển thị trên màn hình.
class PhotoSelectorCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  
  // assetQueue cần xem xét lại có phù hợp không
//  var assetQueue: DispatchQueue!
  var requestId: PHImageRequestID!
  
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
  
  /// Reset lại trạng thái của cell trước khi được reuse.
  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
    // khi scroll quá nhanh + cơ chế reuse cell
    // dẫn đến ảnh bị nhảy lung tung.
    // Trước khi reuse lại cell, những cell bị lướt qua (không hiển thị) cancel request.
    PHImageManager.default().cancelImageRequest(requestId)
  }
  
  /// Configure `photoImageView` trong cell với `asset` được truyền vào.
  func configure(withAsset asset: PHAsset) {
    let targetSize = CGSize(width: bounds.size.width * 4, height: bounds.size.height * 4)
    
    requestId = asset.getImageAsync(targetSize: targetSize) { [weak self] image in
      if let image = image {
        self?.photoImageView.image = image
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
