//
//  PhotoSelectorHeader.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 22/04/2023.
//

import UIKit
import Photos

protocol PhotoSelectorHeaderDelegate: AnyObject {
  func didTapCameraButton()
}

class PhotoSelectorHeader: UICollectionReusableView {
  
  static var identifier: String { String(describing: self) }
  
  // MARK: - UI Components
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemBackground
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let separatorView: UIView = {
    let view = UIView()
    view.layer.borderColor = UIColor.darkGray.cgColor
    view.layer.borderWidth = 0.25
    view.backgroundColor = .systemBackground
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var cameraButton: UIButton = {
    let button = UIButton(type: .system)
    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular)
    let image = UIImage(systemName: "camera", withConfiguration: symbolConfig)
    button.setImage(image, for: .normal)
    button.tintColor = .label
    button.layer.cornerRadius = 30 / 2
    button.layer.borderWidth = 1.25
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let separatorViewHeight: CGFloat = 50
  
  weak var delegate: PhotoSelectorHeaderDelegate?
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  @objc private func cameraButtonTapped() {
    delegate?.didTapCameraButton()
  }
  
  func configure(withAsset asset: PHAsset) {
    if let image = asset.getImageFromAsset(targetSize: bounds.size) {
      photoImageView.image = image
      print(image.size)
    }
  }
  
  // MARK: - UI Layout
  private func setupView() {
    addSubview(containerView)
    addSubview(photoImageView)
    addSubview(separatorView)
    separatorView.addSubview(cameraButton)
    
    NSLayoutConstraint.activate([
      containerView.leftAnchor.constraint(equalTo: leftAnchor),
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.rightAnchor.constraint(equalTo: rightAnchor),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
      photoImageView.topAnchor.constraint(equalTo: topAnchor),
      photoImageView.rightAnchor.constraint(equalTo: rightAnchor),
      photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -separatorViewHeight),
      
      separatorView.leftAnchor.constraint(equalTo: leftAnchor),
      separatorView.rightAnchor.constraint(equalTo: rightAnchor),
      separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: separatorViewHeight),
      
      cameraButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
      cameraButton.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor),
      cameraButton.widthAnchor.constraint(equalToConstant: 30),
      cameraButton.heightAnchor.constraint(equalTo: cameraButton.widthAnchor)
    ])
  }
}
