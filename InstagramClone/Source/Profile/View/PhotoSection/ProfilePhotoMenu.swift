//
//  ProfilePhotoMenu.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 06/05/2023.
//

import UIKit

// MARK: - MenuType
extension ProfilePhotoMenu {
  enum MenuType: Int, CaseIterable {
    case allMedia
    case reels
    case tagged
    
    var description: String {
      switch self {
        case .allMedia: return "gird_icon"
        case .reels: return "reels_icon"
        case .tagged: return "tagged_icon"
      }
    }
  }
}

protocol ProfilePhotoMenuDelegate: AnyObject {
  func didSelectItemAtIndex(withMenuType type: ProfilePhotoMenu.MenuType)
}

// MARK: - ProfilePhotoMenu
class ProfilePhotoMenu: UIView {
  
  weak var delegate: ProfilePhotoMenuDelegate?
  private var numberOfItemsInSection: Int { MenuType.allCases.count }
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    collectionView.register(
      ProfilePhotoMenuCell.self,
      forCellWithReuseIdentifier: ProfilePhotoMenuCell.identifier
    )
    collectionView.dataSource = self
    collectionView.delegate = self
    
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(collectionView)
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}

// MARK: - UICollectionViewDataSource
extension ProfilePhotoMenu: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return numberOfItemsInSection
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProfilePhotoMenuCell.identifier,
      for: indexPath) as! ProfilePhotoMenuCell
    cell.type = MenuType(rawValue: indexPath.item)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = collectionView.frame.size.width / CGFloat(numberOfItemsInSection)
    let height = collectionView.frame.size.height
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    
    guard let type = MenuType(rawValue: indexPath.item) else { return }
    delegate?.didSelectItemAtIndex(withMenuType: type)
  }
  
}

// MARK: - ProfilePhotoMenuCell
class ProfilePhotoMenuCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  var type: ProfilePhotoMenu.MenuType! {
    didSet { iconImageView.image = UIImage(named: type.description) }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    contentView.addSubview(iconImageView)
    NSLayoutConstraint.activate([
      iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: 23),
      iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
