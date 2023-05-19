//
//  StatusView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import UIKit

class StatusView: UIView {

  var backButtonTapped: (() -> Void)?
  
  var title: String? {
    didSet { titleLabel.text = title }
  }
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var backButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    button.tintColor = .label
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc private func didTapBackButton() {
    self.backButtonTapped?()
  }
  
  private func setupConstraints() {
    addSubview(backButton)
    addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
      backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      backButton.widthAnchor.constraint(equalToConstant: 22),
      backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
      
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
