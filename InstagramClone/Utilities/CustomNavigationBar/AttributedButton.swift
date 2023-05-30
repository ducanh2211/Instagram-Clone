//
//  AttributedButton.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 23/05/2023.
//

import UIKit

struct AttributedButton {
  var image: UIImage?
  var title: String?
  var font: UIFont?
  var color: UIColor
  var size: CGSize?
  var action: (() -> Void)?
  
  init() {
    self.image = nil
    self.title = "Button"
    self.font = .systemFont(ofSize: 16)
    self.color = .link
    self.size = nil
    self.action = nil
  }
  
  init(image: UIImage,
       color: UIColor = .label,
       size: CGSize? = nil,
       action: (() -> Void)? = nil) {
    
    self.image = image
    self.color = color
    self.size = size
    self.action = action
  }
  
  init(title: String,
       font: UIFont = .systemFont(ofSize: 16, weight: .semibold),
       color: UIColor = .link,
       action: (() -> Void)? = nil) {
    
    self.title = title
    self.font = font
    self.color = color
    self.action = action
  }
}
