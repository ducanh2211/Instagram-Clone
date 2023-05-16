//
//  UIView + Extension.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

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
  
  func pinToView(_ view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      leftAnchor.constraint(equalTo: view.leftAnchor),
      topAnchor.constraint(equalTo: view.topAnchor),
      rightAnchor.constraint(equalTo: view.rightAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
