//
//  ProfileHeaderMainView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

protocol ProfileHeaderMainViewDelegate: AnyObject {
  func didTapFollowOrEditButton()
  func didTapMessageOrShareButton()
}

class ProfileHeaderMainView: UIView {

  // MARK: - UI Components
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "vtv24-logo")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 86/2
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let postsLabel = UserStatLabel(type: .posts, value: 2211)
  private let followerslabel = UserStatLabel(type: .followers, value: 8888)
  private let followingLabel = UserStatLabel(type: .following, value: 8888)
  
  private let fullNameLabel: UILabel = {
    let label = UILabel()
    label.text = "VTV DIGITAL"
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let bioLabel: UILabel = {
    let label = UILabel()
    label.text = "2 dong\nthuc su luon\nsao lai the\nthuc the nao the\nthan thanh"
    label.numberOfLines = 3
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var followOrEditButton: ActionProfileButton = {
    let button = ActionProfileButton(type: .system)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(followOrEditButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var messageOrShareButton: ActionProfileButton = {
    let button = ActionProfileButton(type: .system)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(messageOrShareButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private lazy var seeMoreButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    button.setTitle("See more", for: .normal)
    button.setTitleColor(UIColor.lightGray, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    button.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Initializer
  let bioText: String
  weak var delegate: ProfileHeaderMainViewDelegate?
  
  init(bioText: String) {
    self.bioText = bioText
    super.init(frame: .zero)
    setupView()
    bioLabel.text = bioText
    configureSeeMoreButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  @objc private func followOrEditButtonDidTap() {
    delegate?.didTapFollowOrEditButton()
  }
  
  @objc private func messageOrShareButtonDidTap() {
    delegate?.didTapMessageOrShareButton()
  }
  
  @objc private func seeMoreButtonTapped() {
    bioLabel.numberOfLines = 0
    seeMoreButton.isHidden = true
  }
  
  private func configureSeeMoreButton() {
    DispatchQueue.main.async {
      let isTruncated = self.bioLabel.isTextTruncated()
      self.seeMoreButton.isHidden = isTruncated ? false : true
    }
  }
}

// MARK: - UI Layout
extension ProfileHeaderMainView {
  private func setupView() {
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
      
      seeMoreButton.heightAnchor.constraint(equalToConstant: 15),
      userInfoStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
      userInfoStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
      userInfoStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
      buttonStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
      buttonStack.topAnchor.constraint(equalTo: userInfoStack.bottomAnchor, constant: 8),
      buttonStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
      buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
      buttonStack.heightAnchor.constraint(equalToConstant: 30)
    ])
  }
}
