//
//  ProfilePhotoCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

class ProfilePhotoCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  
  let numberOfItemsPerRow: CGFloat = 3
  let itemContentInsets: CGFloat = 0.5
  let sectionInterSpacing: CGFloat = 4
  
  lazy var menuView: ProfilePhotoMenu = {
    let view = ProfilePhotoMenu()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.delegate = self
    return view
  }()
  var collectionView: UICollectionView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    collectionView.isScrollEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - UICollectionViewDataSource
extension ProfilePhotoCell: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommonPhotoCell.identifier, for: indexPath) as! CommonPhotoCell
    cell.backgroundColor = .systemIndigo
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension ProfilePhotoCell: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset
    let screenWidth = UIScreen.main.bounds.width
    let currentPage = round(currentOffset.x / screenWidth)
    
    if currentOffset.x <= currentPage * screenWidth {
      UIView.animate(withDuration: 0.15) {
        self.collectionView.contentOffset.x += currentPage * self.sectionInterSpacing
      }
    }
  }
}

// MARK: - ProfilePhotoMenuDelegate
extension ProfilePhotoCell: ProfilePhotoMenuDelegate {
  func didSelectItemAtIndex(withMenuType type: ProfilePhotoMenu.MenuType) {
    let section = type.rawValue
    let screenWidth = UIScreen.main.bounds.width
    
    UIView.animate(withDuration: 1) {
      self.collectionView.contentOffset.x = CGFloat(section) * (screenWidth + self.sectionInterSpacing)
    }
    
//    let indexPath = IndexPath(item: 0, section: section)
//    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}
