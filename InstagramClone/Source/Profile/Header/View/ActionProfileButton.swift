//
//  UserProfileButton2.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

class ActionProfileButton: UIButton {

  enum ActionProfileButtonType: String {
    case loading = "Loading"
    case follow = "Follow"
    case following = "Following"
    case message = "Message"
    case editProfile = "Edit profile"
    case shareProfile = "Share profile"
  }
  
  private(set) var userButtonType: ActionProfileButtonType  = .loading
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialSetup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setActionButtonType(type: ActionProfileButtonType) {
    self.userButtonType = type
  }
  
  private func initialSetup() {
    backgroundColor = .systemGray3
    layer.cornerRadius = 6
    setTitle(userButtonType.rawValue, for: .normal)
    setTitleColor(UIColor.label, for: .normal)
    
    switch userButtonType {
      case .follow:
        backgroundColor = .link
        setTitleColor(UIColor.white, for: .normal)
      default:
        break
    }
  }
}
