//
//  Extentsion.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import Foundation
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

extension NSMutableAttributedString {
  func appendAttributedString(_ str: String,
                              font: UIFont? = nil,
                              color: UIColor? = nil) -> NSMutableAttributedString {
    
    var attributes = [NSAttributedString.Key: Any]()
    
    if let font = font {
      attributes[.font] = font
    }
    if let color = color {
      attributes[.foregroundColor] = color
    }
    
    let str = NSMutableAttributedString(string: str, attributes: attributes)
    self.append(str)
    return self
  }
}

extension UIViewController {
  func hideKeyBoardWhenTapped() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

extension UIView {
  func dropShadow(color: UIColor = .gray,
                  opacity: Float = 0.1,
                  offSet: CGSize = .zero,
                  radius: CGFloat = 1,
                  scale: Bool = true) {
    
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius
    
    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
