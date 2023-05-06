//
//  ProfilePhotoCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

class ProfilePhotoCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  
  var collectionView: UICollectionView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    
  }
  
  
}

/**
 private func createLayout() -> UICollectionViewCompositionalLayout {
   let itemInsets: CGFloat = 0.35
   let numberOfItemsInGroup: CGFloat = 3
   
   // Item
   let itemSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1 / numberOfItemsInGroup),
     heightDimension: .fractionalHeight(1)
   )
   let item = NSCollectionLayoutItem(layoutSize: itemSize)
   item.contentInsets = NSDirectionalEdgeInsets(
     top: itemInsets, leading: itemInsets,
     bottom: itemInsets, trailing: itemInsets
   )
   
   // Group
   let groupSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1),
     heightDimension: .fractionalWidth(1 / numberOfItemsInGroup)
   )
   let group = NSCollectionLayoutGroup.horizontal(
     layoutSize: groupSize,
     subitems: [item]
   )
   
   // Section
   let section = NSCollectionLayoutSection(group: group)
   section.contentInsets = NSDirectionalEdgeInsets(
     top: 0, leading: itemInsets,
     bottom: 0, trailing: itemInsets
   )
//    section.orthogonalScrollingBehavior = .paging
   
   // Supplementary items
   let supplementaryItemSize = NSCollectionLayoutSize(
     widthDimension: .fractionalWidth(1.0),
     heightDimension: .estimated(200)
   )
   let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
     layoutSize: supplementaryItemSize,
     elementKind: UICollectionView.elementKindSectionHeader,
     alignment: .top
   )
   supplementaryItem.pinToVisibleBounds = false
   section.boundarySupplementaryItems = [supplementaryItem]
   
   // Layout
   let configuration = UICollectionViewCompositionalLayoutConfiguration()
   configuration.interSectionSpacing = 5
   let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
   
   return layout
 }
 **/
