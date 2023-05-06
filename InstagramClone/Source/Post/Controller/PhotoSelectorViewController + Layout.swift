//
//  PhotoSelectorViewController + Layout.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 23/04/2023.
//

import UIKit

// MARK: - UI Layout
extension PhotoSelectorViewController {
  
  // MARK: View
  func setupView() {
    self.title = "New post"
    self.view.backgroundColor = .systemBackground
    ProgressHUD.colorHUD = .black
    ProgressHUD.colorAnimation = .white
    setupCollectionView()
    setupConstraints()
    setupNavigationBar()
  }
  
  private func setupConstraints() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupNavigationBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemBackground
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    navigationController?.navigationBar.backgroundColor = .systemBackground
    navigationController?.navigationBar.tintColor = .label
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark"),
      style: .done,
      target: self,
      action: #selector(closeButtonTapped)
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Next",
      style: .done,
      target: self,
      action: #selector(nextButtonTapped)
    )
    navigationItem.rightBarButtonItem?.tintColor = .link
  }
  
  // MARK: Collection view
  private func setupCollectionView() {
    let layout = createLayout()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(
      PhotoSelectorCell.self,
      forCellWithReuseIdentifier: PhotoSelectorCell.identifier
    )
    collectionView.register(
      PhotoSelectorHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: PhotoSelectorHeader.identifier
    )
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    let itemInsets: CGFloat = 0.5
    let numberOfItemsInGroup: CGFloat = 4
    
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
    
    // Supplementary items
    let supplementaryItemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(0.5)
    )
    let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: supplementaryItemSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    supplementaryItem.pinToVisibleBounds = true
    section.boundarySupplementaryItems = [supplementaryItem]
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}
