//
//  PhotoSelectorViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/04/2023.
//

import UIKit

class PhotoSelectorViewController: UIViewController {

  private var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupConstraints()
  }
    
}

extension PhotoSelectorViewController {
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
  
  private func setupCollectionView() {
    let layout = createLayout()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
//    collectionView.register(, forCellWithReuseIdentifier: )
    
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    let numberOfItemsInGroup: CGFloat = 3
    let itemInsets: CGFloat = 2
    
    // Item
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/numberOfItemsInGroup),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: itemInsets, leading: itemInsets,
                                                 bottom: itemInsets, trailing: itemInsets)
    
    // Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .fractionalWidth(1/numberOfItemsInGroup))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
}

extension PhotoSelectorViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
}
