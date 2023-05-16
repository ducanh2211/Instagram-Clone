//
//  DAPagingDatasource.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

protocol PagingViewControllerDataSource: AnyObject {
  func numberOfPageControllers(in pagingViewController: PagingViewController) -> Int
  func pagingViewController(_ pagingViewController: PagingViewController, pageControllerAt index: Int) -> UIViewController
  func menuItems(in pagingViewController: PagingViewController) -> [DefaultMenuItem]
}
