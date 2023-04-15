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
  
//  override var intrinsicContentSize: CGSize {
//    let width = UIScreen.main.bounds.width
//    return CGSize(width: width, height: 44)
//  }
  
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
  
  private let seperatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray5
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
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
    addSubview(seperatorView)
    
    NSLayoutConstraint.activate([
      backButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
      backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      backButton.widthAnchor.constraint(equalToConstant: 22),
      backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
      
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      seperatorView.leftAnchor.constraint(equalTo: leftAnchor),
      seperatorView.rightAnchor.constraint(equalTo: rightAnchor),
      seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      seperatorView.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}
