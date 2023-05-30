//
//  Protocol.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 12/05/2023.
//

import Foundation

protocol PagingViewControllerDelegate: AnyObject {
  /// Lấy current index của paging view controller.
  /// - Parameters:
  ///   - pagingViewController: instance quản lý các page controller.
  ///   - currentIndex: index của page controller hiện tại.
  func pagingViewController(_ pagingViewController: PagingViewController,
                            getCurrentIndex currentIndex: Int)
  
  /// Transition giữa các page controller đang được thực hiện.
  /// - Parameters:
  ///   - pagingViewController: instance quản lý các page controller.
  ///   - fromIndex: index của menu chuẩn bị transition.
  ///   - toIndex: index của menu có thể được transition đến.
  ///   - currentIndex: index thực sự của menu tại thời điểm đang transition.
  ///   - progress: phần trăm hoàn thành của transition được biểu diễn dưới dạng `CGFloat`.
  ///   - indexWasChange: `True` khi current index vừa mới thay đổi.
  ///   - success: `True` khi transition sẽ thành công và index sẽ thay đổi.
  ///   `False` khi transition không thành công và index sẽ giữ nguyên sau transition.
  ///
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didTrasitioningAt currentIndex: Int,
                            progress: CGFloat,
                            indexJustChanged: Bool)
  
  /// Transition giữa các page controller đã hoàn thành.
  /// - Parameters:
  ///   - pagingViewController: instance quản lý các page controller.
  ///   - fromIndex: index của menu chuẩn bị transition.
  ///   - toIndex: index của menu có thể được transition đến.
  ///   - success: `True` khi transition đã được chuyển sang page mới. `False` khi trở lại page ban đầu.
  ///
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didCompleteTransitioning fromIndex: Int,
                            toIndex: Int,
                            success: Bool)
  
  /// Menu item được select.
  /// - Parameters:
  ///   - pagingViewController: instance quản lý các page controller
  ///   - index: index của menu đã được transistion đến.
  ///
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didSelectMenuItemAtIndex currentIndex: Int)
}

extension PagingViewControllerDelegate {
  func pagingViewController(_ pagingViewController: PagingViewController,
                            getCurrentIndex index: Int) {
    return
  }
  
  
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didTrasitioningAt currentIndex: Int,
                            progress: CGFloat,
                            indexJustChanged: Bool) {
    return
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didCompleteTransitioning fromIndex: Int, toIndex: Int, success: Bool) {
    return
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didSelectMenuItemAtIndex currentIndex: Int) {
    return
  }
}
