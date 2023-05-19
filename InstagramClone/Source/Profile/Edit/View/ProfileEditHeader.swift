//
//  ProfileEditHeader.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

protocol ProfileEditHeaderDelegate: AnyObject {
  func didTapEditAvatarButton()
}

class ProfileEditHeader: UIView {

  private let profileImageView: UIImageView = {
    let imv = UIImageView()
    imv.translatesAutoresizingMaskIntoConstraints = false
    imv.contentMode = .scaleAspectFit
    imv.clipsToBounds = true
    imv.layer.cornerRadius = 80/2
    imv.image = UIImage(named: "vtv24-logo")
    return imv
  }()
  
  private lazy var editAvatarButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Edit picture or avatar", for: .normal)
    btn.setTitleColor(UIColor.link, for: .normal)
    btn.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    btn.addTarget(self, action: #selector(didTapEditAvatarButton), for: .touchUpInside)
    return btn
  }()
  
  weak var delegate: ProfileEditHeaderDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func didTapEditAvatarButton() {
    delegate?.didTapEditAvatarButton()
  }
  
  private func setup() {
    addSubview(profileImageView)
    addSubview(editAvatarButton)
    
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      profileImageView.widthAnchor.constraint(equalToConstant: 80),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
      profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        
      editAvatarButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
      editAvatarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      editAvatarButton.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
}
