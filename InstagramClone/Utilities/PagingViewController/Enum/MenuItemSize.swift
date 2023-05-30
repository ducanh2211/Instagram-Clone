//
//  MenuItemSize.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import Foundation

enum MenuItemSize {
  case fill(height: CGFloat)
}

extension MenuItemSize {
  var menuHeight: CGFloat {
    switch self {
      case .fill(let height):
        return height
    }
  }
}
