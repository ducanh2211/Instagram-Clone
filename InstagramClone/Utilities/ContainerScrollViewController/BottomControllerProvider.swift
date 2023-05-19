//
//  BottomControllerProvider.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

protocol BottomControllerProvider where Self: UIViewController {
  var menuItemHeight: CGFloat { get }
  var currentViewController: UIViewController { get }
  var delegate: BottomControllerProviderDelegate? { get set }
}
