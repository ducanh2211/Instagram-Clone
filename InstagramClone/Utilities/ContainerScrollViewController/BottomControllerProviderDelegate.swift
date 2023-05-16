//
//  DABottomDelegate.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

protocol BottomControllerProviderDelegate: AnyObject {
  func bottomControllerProvider(_ bottomControllerProvider: BottomControllerProvider, currentViewController: UIViewController, currentIndex: Int)
}
