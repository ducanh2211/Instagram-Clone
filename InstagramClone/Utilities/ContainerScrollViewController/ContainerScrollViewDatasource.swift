//
//  ContainerScrollViewDatasource.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 10/05/2023.
//

import UIKit

protocol ContainerScrollViewDatasource: AnyObject {
  var minHeaderViewHeight: CGFloat { get }
  var headerViewController: UIViewController { get }
  var bottomViewController: BottomControllerProvider { get }
}
