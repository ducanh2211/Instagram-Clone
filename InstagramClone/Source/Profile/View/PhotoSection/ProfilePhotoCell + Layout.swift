//
//  ProfilePhotoCell + Layout.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 06/05/2023.
//

import UIKit

extension ProfilePhotoCell {
  func setupView() {
    setupCollectionView()
    setupContraints()
  }
  
  private func setupContraints() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(menuView)
    contentView.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      menuView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      menuView.topAnchor.constraint(equalTo: contentView.topAnchor),
      menuView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      menuView.heightAnchor.constraint(equalToConstant: 44),
      
      collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      collectionView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
      collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  private func setupCollectionView() {
    let layout = createLayout()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.showsVerticalScrollIndicator = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    
    collectionView.register(
      CommonPhotoCell.self,
      forCellWithReuseIdentifier: CommonPhotoCell.identifier
    )
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .horizontal
    configuration.interSectionSpacing = sectionInterSpacing
    
    let layout = UICollectionViewCompositionalLayout(sectionProvider: {
      sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
      
      switch ProfilePhotoMenu.MenuType(rawValue: sectionIndex) {
        case .allMedia:
          return self.createAllMediaSection()
        case .reels:
          return self.createReelsSection()
        case .tagged:
          return self.createTaggedSection()
        default:
          return nil
      }
    }, configuration: configuration)
    
    return layout
  }
  
  private func createAllMediaSection() -> NSCollectionLayoutSection {
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/numberOfItemsPerRow),
      heightDimension: .fractionalWidth(1/numberOfItemsPerRow)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: itemContentInsets,
      leading: itemContentInsets,
      bottom: itemContentInsets,
      trailing: itemContentInsets
    )
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1/numberOfItemsPerRow)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    
    return section
  }
  
  private func createReelsSection() -> NSCollectionLayoutSection {
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/numberOfItemsPerRow),
      heightDimension: .fractionalWidth(1/numberOfItemsPerRow)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: itemContentInsets,
      leading: itemContentInsets,
      bottom: itemContentInsets,
      trailing: itemContentInsets
    )
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1/numberOfItemsPerRow)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    
    return section
  }
  
  private func createTaggedSection() -> NSCollectionLayoutSection {
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1/numberOfItemsPerRow),
      heightDimension: .fractionalWidth(1/numberOfItemsPerRow)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(
      top: itemContentInsets,
      leading: itemContentInsets,
      bottom: itemContentInsets,
      trailing: itemContentInsets
    )
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalWidth(1/numberOfItemsPerRow)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    
    return section
  }
}
