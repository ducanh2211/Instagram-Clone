//
//  PagingMenuSettings.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 12/05/2023.
//

import UIKit

struct PagingMenuSettings {
  var itemSize: MenuItemSize
  var indicatorHeight: CGFloat
  var separatorHeight: CGFloat
  var separatorColor: UIColor
  let itemSpacing: CGFloat
  var normalColor: UIColor
  var selectedColor: UIColor
  var normalFont: UIFont
  var selectedFont: UIFont
  var transitionTimeInterval: TimeInterval
  
  init() {
    self.itemSize = .fill(height: 44)
    self.indicatorHeight = 1
    self.separatorHeight = 1
    self.separatorColor = .systemGray3
    self.itemSpacing = 10
    self.normalColor = .red
    self.selectedColor = .blue
    self.normalFont = .systemFont(ofSize: 13)
    self.selectedFont = .systemFont(ofSize: 13, weight: .semibold)
    self.transitionTimeInterval = 0.35
  }
}
