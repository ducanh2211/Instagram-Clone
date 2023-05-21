//
//  BottomSheetSettings.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 20/05/2023.
//

import UIKit

// MARK: - BottomSheetType
enum BottomSheetType {
  case fill
  case float(leftSpacing: CGFloat, rightSpacing: CGFloat, bottomSpacing: CGFloat)
  
  var spacingFromLeft: CGFloat {
    switch self {
      case .fill:
        return .zero
      case .float(let leftSpacing, _, _):
        return leftSpacing
    }
  }
  
  var spacingFromRight: CGFloat {
    switch self {
      case .fill:
        return .zero
      case .float(_, let rightSpacing, _):
        return rightSpacing
    }
  }
  
  var spacingFromBottom: CGFloat {
    switch self {
      case .fill:
        return .zero
      case .float(_, _, let bottomSpacing):
        return bottomSpacing
    }
  }
}

// MARK: - BottomSheetHeight
enum BottomSheetHeight {
  case medium
  case large
  case custom(height: CGFloat)
  
  var preferedHeight: CGFloat {
    switch self {
      case .medium:
        return UIScreen.main.bounds.height / 2
      case .large:
        guard let window = UIApplication.shared.keyWindow else { return .zero }
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        let topInset = safeFrame.minY
        return window.bounds.height - topInset
      case .custom(let height):
        return height
    }
  }
}

// MARK: - BottomSheetCorner
enum BottomSheetCorner {
  case top(radius: CGFloat)
  case bottom(radius: CGFloat)
  case both(radius: CGFloat)
  
  var preferedRadius: CGFloat {
    switch self {
      case .top(let radius):
        return radius
      case .bottom(let radius):
        return radius
      case .both(let radius):
        return radius
    }
  }
}

// MARK: - BottomSheetSetting
struct BottomSheetSetting {
  var type: BottomSheetType
  var cornerRadius: BottomSheetCorner
  var sheetHeight: BottomSheetHeight
  var grabberVisible: Bool
  
  init() {
    self.type = .fill
    self.cornerRadius = .top(radius: 15)
    self.sheetHeight = .medium
    self.grabberVisible = true
  }
  
  init(type: BottomSheetType,
       cornerRadius: BottomSheetCorner,
       sheetHeight: BottomSheetHeight,
       grabberVisible: Bool) {
    
    self.type = type
    self.cornerRadius = cornerRadius
    self.sheetHeight = sheetHeight
    self.grabberVisible = grabberVisible
  }
}
