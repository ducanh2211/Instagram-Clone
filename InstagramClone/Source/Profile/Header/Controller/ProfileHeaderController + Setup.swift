//
//  ProfileHeaderViewController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 22/05/2023.
//

import UIKit

extension ProfileHeaderController {
  
  func setupView() {
    view.backgroundColor = .systemBackground
    setupCollectionView()
    setupConstraints()
  }
  
  private func setupConstraints() {
    // stat label stack view
    let statLabelStack = UIStackView(arrangedSubviews: [postsLabel, followerslabel, followingLabel])
    statLabelStack.axis = .horizontal
    statLabelStack.distribution = .equalCentering
    statLabelStack.translatesAutoresizingMaskIntoConstraints = false
    
    // user info stack view
    let userInfoStack = UIStackView(arrangedSubviews: [fullNameLabel, bioLabel, seeMoreButton])
    userInfoStack.axis = .vertical
    userInfoStack.alignment = .leading
    userInfoStack.spacing = 1
    userInfoStack.translatesAutoresizingMaskIntoConstraints = false
    
    // button stack view
    let buttonStack = UIStackView(arrangedSubviews: [followOrEditButton, messageOrShareButton])
    buttonStack.axis = .horizontal
    buttonStack.distribution = .fillEqually
    buttonStack.spacing = 6
    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    
    // add subview
    view.addSubview(profileImageView)
    view.addSubview(statLabelStack)
    view.addSubview(userInfoStack)
    view.addSubview(buttonStack)
    view.addSubview(storyCollectionView)
    
    storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    // active constraints
    NSLayoutConstraint.activate([
      profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
      profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
      profileImageView.widthAnchor.constraint(equalToConstant: 86),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
      
      statLabelStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28),
      statLabelStack.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      statLabelStack.widthAnchor.constraint(equalToConstant: 205),
      
      seeMoreButton.heightAnchor.constraint(equalToConstant: 15),
      userInfoStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
      userInfoStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
      userInfoStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
      buttonStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
      buttonStack.topAnchor.constraint(equalTo: userInfoStack.bottomAnchor, constant: 8),
      buttonStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
      buttonStack.heightAnchor.constraint(equalToConstant: 30),
      
      storyCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      storyCollectionView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
      storyCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      storyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
      storyCollectionView.heightAnchor.constraint(equalToConstant: 83)
    ])
  }
  
  private func setupCollectionView() {
    storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    storyCollectionView.dataSource = self
    storyCollectionView.register(ProfileStoryCell.self, forCellWithReuseIdentifier: ProfileStoryCell.identifier)
    storyCollectionView.showsHorizontalScrollIndicator = false
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
