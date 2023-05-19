//
//  HomeViewController + Layout.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

// MARK: - UI Layout
extension HomeViewController {
  
  func setupView() {
    navigationController?.isNavigationBarHidden = true
    setupNavBar()
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupNavBar() {
    let logoButton = AttributedButton(image: UIImage(named: "logo")!)
    
    let config = UIImage.SymbolConfiguration(weight: .medium)
    let image1 = UIImage(systemName: "heart", withConfiguration: config)!
    let notificationButton = AttributedButton(image: image1)
    
    let image2 = UIImage(systemName: "bolt.horizontal.circle", withConfiguration: config)!
    let messageButton = AttributedButton(image: image2)
    
    navBar = CustomNavigationBar(shouldShowSeparator: false,
                                 leftBarButtons: [logoButton],
                                 rightBarButtons: [notificationButton, messageButton])
  }
  
  private func setupCollectionView() {
    let layout = createLayout()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(HomeStoryCell.self, forCellWithReuseIdentifier: HomeStoryCell.identifier)
    collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: HomePostCell.identifier)
  }
  
  private func getSafeAreaTopHeight() -> CGFloat {
    guard let window = UIApplication.shared.keyWindow else { return .zero }
    let safeFrame = window.safeAreaLayoutGuide.layoutFrame
    return safeFrame.minY
  }
  
  private func setupConstraints() {
    view.addSubview(collectionView)
    view.addSubview(navBar)
    view.addSubview(fakeView)
    navBar.translatesAutoresizingMaskIntoConstraints = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      fakeView.leftAnchor.constraint(equalTo: view.leftAnchor),
      fakeView.topAnchor.constraint(equalTo: view.topAnchor),
      fakeView.rightAnchor.constraint(equalTo: view.rightAnchor),
      fakeView.heightAnchor.constraint(equalToConstant: getSafeAreaTopHeight()),
      
      navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
      navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
      navBar.heightAnchor.constraint(equalToConstant: navBarHeight),
      
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.topAnchor.constraint(equalTo: navBar.topAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout {
      sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
      
      switch HomeSection(rawValue: sectionIndex) {
        case .story:
          return self.createStorySection()
        case .post:
          return self.createPostSection()
        default:
          return nil
      }
    }
    
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    layout.configuration = configuration
    return layout
  }
  
  private func createStorySection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(64),
      heightDimension: .absolute(83)
    )
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: navBarHeight, leading: 14, bottom: 14, trailing: 14)
    section.interGroupSpacing = 18
    section.orthogonalScrollingBehavior = .continuous
    return section
  }
  
  private func createPostSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(600)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(600)
    )
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 20
    return section
  }
}
