//
//  ProfileHeaderCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 06/05/2023.
//

import UIKit

class ProfileHeaderCell: UICollectionViewCell {
    
  static var identifier: String { String(describing: self) }
  
  // MARK: - UI Components
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "person.circle")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 86/2
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let postsLabel = UserStatLabel(type: .posts, value: 0)
  private let followerslabel = UserStatLabel(type: .followers, value: 0)
  private let followingLabel = UserStatLabel(type: .following, value: 0)
  
  private let fullNameLabel: UILabel = {
    let label = UILabel()
    label.text = "duc anh"
    label.font = .systemFont(ofSize: 12, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let bioLabel: UILabel = {
    let label = UILabel()
    label.text = "2 dong\nthuc su luon\nsao lai the"
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var followOrEditButton: UserProfileButton = {
    let button = UserProfileButton(type: .system)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(followOrEditButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var messageOrShareButton: UserProfileButton = {
    let button = UserProfileButton(type: .system)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(messageOrShareButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Life cycle
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  
  @objc private func followOrEditButtonDidTap() {
    print("follow")
  }
  
  @objc private func messageOrShareButtonDidTap() {
    print("message")
  }
  
}

// MARK: - UI Layout

extension ProfileHeaderCell {
  private func setupView() {
    // create stack view
    let statLabelStack = UIStackView(arrangedSubviews: [postsLabel, followerslabel, followingLabel])
    statLabelStack.axis = .horizontal
    statLabelStack.distribution = .equalCentering
    statLabelStack.translatesAutoresizingMaskIntoConstraints = false
    
    let userInfoStack = UIStackView(arrangedSubviews: [fullNameLabel, bioLabel])
    userInfoStack.axis = .vertical
    userInfoStack.alignment = .leading
    userInfoStack.spacing = 2
    userInfoStack.translatesAutoresizingMaskIntoConstraints = false
    
    let buttonStack = UIStackView(arrangedSubviews: [followOrEditButton, messageOrShareButton])
    buttonStack.axis = .horizontal
    buttonStack.distribution = .fillEqually
    buttonStack.spacing = 6
    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    
    // add subview
    addSubview(profileImageView)
    addSubview(statLabelStack)
    addSubview(userInfoStack)
    addSubview(buttonStack)
    
    // active constraints
    NSLayoutConstraint.activate([
      profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
      profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
      profileImageView.widthAnchor.constraint(equalToConstant: 86),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
      
      statLabelStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -28),
      statLabelStack.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
      statLabelStack.widthAnchor.constraint(equalToConstant: 205),
      
      userInfoStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
      userInfoStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
      userInfoStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
      
      buttonStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
      buttonStack.topAnchor.constraint(equalTo: userInfoStack.bottomAnchor, constant: 15),
      buttonStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
      buttonStack.heightAnchor.constraint(equalToConstant: 30),
      buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
    ])
  }
}
