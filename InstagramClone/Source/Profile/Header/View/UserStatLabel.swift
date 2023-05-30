//
//  UserStatLabel2.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

class UserStatLabel: UILabel {

  enum UserStatType: String {
    case posts = "Posts"
    case followers = "Followers"
    case following = "Following"
  }
  
  private let type: UserStatType
  private var value: Int
  
  init(type: UserStatType, value: Int) {
    self.type = type
    self.value = value
    super.init(frame: .zero)
    initialSetup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func initialSetup() {
    numberOfLines = 2
    textAlignment = .center
    lineBreakMode = .byWordWrapping
    configureText()
  }
  
  func setValue(_ value: Int) {
    self.value = value
    configureText()
  }
  
  private func configureText() {
    let attributedText = NSMutableAttributedString()
      .appendAttributedString("\(value)\n", font: .systemFont(ofSize: 16, weight: .semibold), color: .label)
      .appendAttributedString(type.rawValue, font: .systemFont(ofSize: 13, weight: .regular), color: .label)
    self.attributedText = attributedText
  }
  
}

