//
//  ProfileNavBar.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

class ProfileNavBar: UIView {
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var configureButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
    button.tintColor = .label
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(configureButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Initializer
  var configureButtonTapped: (() -> Void)?
  
  var title: String? {
    didSet { titleLabel.text = title }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func configureButtonDidTap() {
    configureButtonTapped?()
  }
  
  private func setupView() {
    addSubview(titleLabel)
    addSubview(configureButton)
    
    NSLayoutConstraint.activate([
      titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      configureButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
      configureButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      configureButton.widthAnchor.constraint(equalToConstant: 22),
      configureButton.heightAnchor.constraint(equalTo: configureButton.widthAnchor)
    ])
  }
}
