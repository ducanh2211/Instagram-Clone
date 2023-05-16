//
//  DAMenuItem.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 12/05/2023.
//

import UIKit

struct DefaultMenuItem: MenuItemProvider {
  var title: String?
  var normalImage: UIImage?
  var selectedImage: UIImage?
  
  init(title: String) {
    self.title = title
  }
  
  init(normalImage: UIImage) {
    self.normalImage = normalImage
  }
  
  init(normalImage: UIImage, selectedImage: UIImage) {
    self.normalImage = normalImage
    self.selectedImage = selectedImage
  }
}
