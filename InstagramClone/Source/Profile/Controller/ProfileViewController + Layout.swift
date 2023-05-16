//
//  ProfileViewController + Layout.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

//extension ProfileViewController {
//  func setupView() {
//    view.backgroundColor = .systemBackground
//    navigationController?.isNavigationBarHidden = true
//    setupCollectionView()
//    setupContraints()
//  }
//
//  private func setupContraints() {
//    let safeArea = view.safeAreaLayoutGuide
//
//    view.addSubview(statusView)
//    view.addSubview(collectionView)
//    collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      statusView.leftAnchor.constraint(equalTo: view.leftAnchor),
//      statusView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//      statusView.rightAnchor.constraint(equalTo: view.rightAnchor),
//      statusView.heightAnchor.constraint(equalToConstant: 48),
//
//      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
//      collectionView.topAnchor.constraint(equalTo: statusView.bottomAnchor),
//      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
//      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//    ])
//  }
//
//  // MARK: Collection view
//  private func setupCollectionView() {
//    let layout = createLayout()
//    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collectionView.dataSource = self
//    collectionView.showsVerticalScrollIndicator = false
//
//    collectionView.register(
//      ProfileHeaderCell.self,
//      forCellWithReuseIdentifier: ProfileHeaderCell.identifier
//    )
//    collectionView.register(
//      ProfileStoryCell.self,
//      forCellWithReuseIdentifier: ProfileStoryCell.identifier
//    )
//    collectionView.register(
//      ProfilePhotoCell.self,
//      forCellWithReuseIdentifier: ProfilePhotoCell.identifier
//    )
//  }
//
//  private func createLayout() -> UICollectionViewCompositionalLayout {
//    let layout = UICollectionViewCompositionalLayout {
//      sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
//
//      switch SectionType(rawValue: sectionIndex) {
//        case .header:
//          return self.createHeaderSection()
//        case .story:
//          return self.createStorySection()
//        case .photo:
//          return self.createPhotoSection()
//        default:
//          return nil
//      }
//    }
//    return layout
//  }
//
//  /// Tạo `section` cho phần header
//  private func createHeaderSection() -> NSCollectionLayoutSection {
//    // Item
//    let itemSize = NSCollectionLayoutSize(
//      widthDimension: .fractionalWidth(1),
//      heightDimension: .estimated(200)
//    )
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//    // Group
//    let groupSize = NSCollectionLayoutSize(
//      widthDimension: .fractionalWidth(1),
//      heightDimension: .estimated(200)
//    )
//    var group: NSCollectionLayoutGroup
//    if #available(iOS 16.0, *) {
//      group = NSCollectionLayoutGroup.horizontal(
//        layoutSize: groupSize,
//        repeatingSubitem: item,
//        count: 1
//      )
//    }
//    else {
//      group = NSCollectionLayoutGroup.horizontal(
//        layoutSize: groupSize,
//        subitem: item,
//        count: 1
//      )
//    }
//
//    return NSCollectionLayoutSection(group: group)
//  }
//
//  /// Tạo `section` cho phần story
//  private func createStorySection() -> NSCollectionLayoutSection {
//    // Item
//    let itemSize = NSCollectionLayoutSize(
//      widthDimension: .fractionalWidth(1),
//      heightDimension: .estimated(90)
//    )
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//    // Group
//    let groupSize = NSCollectionLayoutSize(
//      widthDimension: .absolute(64),
//      heightDimension: .estimated(90)
//    )
//    let group = NSCollectionLayoutGroup.horizontal(
//      layoutSize: groupSize,
//      subitems: [item]
//    )
//
//    // Section
//    let section = NSCollectionLayoutSection(group: group)
//    section.orthogonalScrollingBehavior = .continuous
//    section.interGroupSpacing = 18
//    section.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
//
//    return section
//  }
//
//  /// Tạo `section` cho phần photo
//  private func createPhotoSection() -> NSCollectionLayoutSection {
//    // Item
//    let itemSize = NSCollectionLayoutSize(
//      widthDimension: .fractionalWidth(1),
//      heightDimension: .estimated(600)
//    )
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//    // Group
//    let groupSize = NSCollectionLayoutSize(
//      widthDimension: .fractionalWidth(1),
//      heightDimension: .estimated(600)
//    )
//    var group: NSCollectionLayoutGroup
//    if #available(iOS 16.0, *) {
//      group = NSCollectionLayoutGroup.horizontal(
//        layoutSize: groupSize,
//        repeatingSubitem: item,
//        count: 1
//      )
//    }
//    else {
//      group = NSCollectionLayoutGroup.horizontal(
//        layoutSize: groupSize,
//        subitem: item,
//        count: 1
//      )
//    }
//
//    return NSCollectionLayoutSection(group: group)
//  }
//}
