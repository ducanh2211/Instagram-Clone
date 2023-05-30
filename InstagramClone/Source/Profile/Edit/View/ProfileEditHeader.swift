//
//  ProfileEditHeader.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

protocol ProfileEditHeaderDelegate: AnyObject {
  func didTapEditAvatarButton()
  func didTapAvatarImage()
}

class ProfileEditHeader: UIView {

  // MARK: - Properties

  private lazy var profileImageView: UIImageView = {
    let imv = UIImageView()
    imv.translatesAutoresizingMaskIntoConstraints = false
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    imv.layer.cornerRadius = 80/2
    imv.isUserInteractionEnabled = true
    imv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAvatarImage)))
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
  
  var profileImage: UIImage? {
    didSet { profileImageView.image = profileImage }
  }
  var profileImageString: String! {
    didSet { profileImageView.sd_setImage(with: URL(string: profileImageString), placeholderImage: UIImage(named: "user"), context: nil) }
  }
  weak var delegate: ProfileEditHeaderDelegate?

  // MARK: - Initializer

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("DEBUG: ProfileEditHeader deinit")
  }
  
  // MARK: - Functions

  @objc private func didTapAvatarImage() {
    delegate?.didTapAvatarImage()
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
      profileImageView.heightAnchor.constraint(equalToConstant: 80),
      profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        
      editAvatarButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
      editAvatarButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
      editAvatarButton.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
}
