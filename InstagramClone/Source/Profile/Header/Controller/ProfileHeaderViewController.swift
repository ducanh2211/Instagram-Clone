//
//  ProfileHeaderViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

// MARK: - Protocol
protocol ProfileHeaderViewControllerDelegate: AnyObject {
  func didTapFollowOrEditButton()
  func didTapMessageOrShareButton()
}

class ProfileHeaderViewController: UIViewController {
  
  private var headerView: ProfileHeaderMainView!
  private var storyCollectionView: UICollectionView!
  weak var delegate: ProfileHeaderViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupHeaderView()
    setupCollectionView()
    setupConstraints()
  }
  
}

// MARK: - ProfileHeaderMainViewDelegate
extension ProfileHeaderViewController: ProfileHeaderMainViewDelegate {
  
  func didTapFollowOrEditButton() {
    delegate?.didTapFollowOrEditButton()
  }
  
  func didTapMessageOrShareButton() {
    delegate?.didTapMessageOrShareButton()
  }
  
}

// MARK: - UICollectionViewDataSource
extension ProfileHeaderViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ProfileStoryCell.identifier,
      for: indexPath) as! ProfileStoryCell
    return cell
  }

}

// MARK: - Setup
extension ProfileHeaderViewController {
  
  private func setupCollectionView() {
    storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    storyCollectionView.dataSource = self
    storyCollectionView.register(ProfileStoryCell.self, forCellWithReuseIdentifier: ProfileStoryCell.identifier)
    storyCollectionView.showsHorizontalScrollIndicator = false
  }
  
  private func setupHeaderView() {
    headerView = ProfileHeaderMainView(bioText: "Bio text that have 5 line \nFor sure \nLine3 \nLine4 \nLine5\nLine3 \nLine4 \nLine5")
    headerView.delegate = self
  }
  
  private func setupConstraints() {
    view.addSubview(headerView)
    view.addSubview(storyCollectionView)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
      
      storyCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      storyCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
      storyCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      storyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
      storyCollectionView.heightAnchor.constraint(equalToConstant: 83)
    ])
  }
  
  private func createLayout() -> UICollectionViewCompositionalLayout {
    // Item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .fractionalHeight(1)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // Group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .absolute(64),
      heightDimension: .fractionalHeight(1)
    )
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: groupSize,
      subitems: [item]
    )
    
    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 0, leading: 14, bottom: 0, trailing: 14)
    section.interGroupSpacing = 18
    
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .horizontal
    let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    
    return layout
  }
  
}
