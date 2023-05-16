//
//  ProfilePhotoDisplayController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class ProfilePhotoDisplayController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: false)
    collectionView.register(UICollectionViewCell.self,
                            forCellWithReuseIdentifier: reuseIdentifier)
    
    
  }
  
  
}

// MARK: - UICollectionViewDataSource
extension ProfilePhotoDisplayController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    
    return 6
  }
  
  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    cell.backgroundColor = .systemCyan
    return cell
  }
}

// MARK: -
extension ProfilePhotoDisplayController {
  private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/3),
      heightDimension: .fractionalWidth(1/3)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = .init(top: 0, leading: 0.5, bottom: 0, trailing: 0.5)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1)
      , heightDimension: .fractionalWidth(1/3)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 1
    return UICollectionViewCompositionalLayout(section: section)
  }
}
