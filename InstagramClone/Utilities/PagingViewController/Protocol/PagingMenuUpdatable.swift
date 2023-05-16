//
//  PagingMenuUpdatable.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 13/05/2023.
//

import Foundation

protocol PagingMenuUpdatable: AnyObject {
  /// Update lại menu item khi transition đang diễn ra (đang được scroll).
  /// - Parameters:
  ///   - fromIndex: index của menu chuẩn bị transition.
  ///   - toIndex: index của menu có thể được transition đến.
  ///   - progress: phần trăm hoàn thành của transition được biểu diễn dưới dạng `CGFloat`.
  ///   - indexWasChange: `True` khi current index vừa mới thay đổi.
  ///   - success: `True` khi transition sẽ thành công và index sẽ thay đổi.
  ///   `False` khi transition không thành công và index sẽ giữ nguyên sau transition.
  ///
  func didTransitioning(fromIndex: Int, toIndex: Int, progress: CGFloat, indexWasChange: Bool, success: Bool)
  
  /// Update lại menu item khi transition đã hoàn thành (đã scroll xong).
  /// - Parameters:
  ///   - fromIndex: index của menu chuẩn bị transition.
  ///   - toIdex: index của menu có thể được transition đến.
  ///   - success: `True` khi transition đã được chuyển sang page mới. `False` khi trở lại page ban đầu.
  ///
  func didCompleteTransition(fromIndex: Int, toIdex: Int, success: Bool)
}
