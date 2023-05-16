//
//  MenuItemProvider.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 13/05/2023.
//

import UIKit

protocol MenuItemProvider {
  var title: String? { get }
  var normalImage: UIImage? { get }
  var selectedImage: UIImage? { get }
}
