//
//  Extentsion.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

extension UITextField {
  func setPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
    if let left = left {
      let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
      self.leftViewMode = .always
      self.leftView = leftView
    }
    if let right = right {
      let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
      self.rightViewMode = .always
      self.rightView = rightView
    }
  }
}

extension UILabel {
  func isTextTruncated() -> Bool {
    guard let text = text else { return false }
    let labelTextHeight = text.height(constrainedWidth: bounds.width, font: font)
    return labelTextHeight > bounds.height
  }
}

extension Notification.Name {
  static let reloadUserProfileFeed = Notification.Name("reloadUserProfileFeed")
}

extension UIApplication {
  var keyWindow: UIWindow? {
    UIApplication
        .shared
        .connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .last
  }
}
