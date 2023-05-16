//
//  MenuItemSize.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import Foundation

enum MenuItemSize {
  case fixed(width: CGFloat, height: CGFloat)
  case flexible(minWidth: CGFloat, height: CGFloat)
  case fill(height: CGFloat)
}

extension MenuItemSize {
  var menuHeight: CGFloat {
    switch self {
      case .fixed(_, let height):
        return height
      case .flexible(_, let height):
        return height
      case .fill(let height):
        return height
    }
  }
}
