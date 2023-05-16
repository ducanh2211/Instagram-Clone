//
//  PagingMenuCell.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

protocol PagingMenuCell where Self: UICollectionViewCell {
  func configurePagingCell(with menuItem: DefaultMenuItem) 
}

