//
//  PagingMenuCollectionViewLayout.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

struct PagingMenuCollectionViewLayout {
  private var numberOfItems: Int 
  private var settings: PagingMenuSettings
  private var menuItemSize: MenuItemSize
  private var menuItemSpacing: CGFloat
  
  init(numberOfItems: Int, settings: PagingMenuSettings) {
    self.numberOfItems = numberOfItems
    self.settings = settings
    self.menuItemSize = settings.itemSize
    self.menuItemSpacing = settings.itemSpacing
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    var group: NSCollectionLayoutGroup
    
    // Group
    switch menuItemSize {
      case .fill(let height):
        let size = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(height)
        )
        group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitem: item,
          count: numberOfItems
        )
    }
    
    let section = NSCollectionLayoutSection(group: group)
    
    // Footer view
    let supplementaryItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(1)
    )
    let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: supplementaryItemSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom)
    section.boundarySupplementaryItems = [supplementaryItem]
    
    // Layout
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .horizontal
    return UICollectionViewCompositionalLayout(section: section, configuration: configuration)
  }
}
