//
//  PagingViewController.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

class PagingViewController: UIViewController {

    // MARK: - Properties

    weak var dataSource: PagingViewControllerDataSource!
    weak var delegate: PagingViewControllerDelegate?

    var pageWidth: CGFloat {
        view.frame.width
    }

    private var numberOfPages: Int {
        dataSource.numberOfPageControllers(in: self)
    }

    private var contentWidth: CGFloat {
        view.frame.width * CGFloat(numberOfPages)
    }

    private var maximumContentOffset: CGFloat {
        view.frame.width * CGFloat(numberOfPages - 1)
    }

    /// Là index của page hiện tại, nó sẽ được cập nhât "real-time" với scroll.
    /// Ví dụ: Scroll từ page0 sang page1, khi progress từ 0.0 -> 0.49999 thì `currentIndex` không đổi và = 0,
    /// progress = 0.5 thì `currentIndex` = 1, progress > 0.5 thì `currentIndex` khổng đổi và = 1.
    /// Nếu như quá trình scroll không kết thúc (i.e. người dùng scroll qua lại cột mốc progress = 0.5) thì `currentIndex` sẽ thay đổi liên tục.
    private var currentIndex: Int = 0 {
        didSet { delegate?.pagingViewController(self, getCurrentIndex: currentIndex) }
    }

    /// Khoảng cách giữa các child controller.
    /// Trường hợp này khó quá, vẫn còn nhiều bug.
    /// Nên set là 0 để khhông có bug.
    let pageSpacing: CGFloat = 0

    /// Là index có khả năng trở thành new index nếu như transition thành công.
    /// Nếu transition thất bại thì nó vẫn giữ nguyên không thay đổi.
    private var potentialNewIndex: Int = 0

    private var successfulTransition: Bool = false

    /// Lưu lại giá trị cuối cùng của content offset
    private var lastContentOffset: CGFloat = 0

    /// Dùng để xác định khi nào menu item được select.
    private var isSelecting: Bool = false

    /// Dùng để nhận biết hướng swipe các child controller.
    private var swipeDirection: SwipeDirection = .undetermine

    let settings: PagingMenuSettings

    /// Master scroll view của cả paging view controller.
    let scrollView: UIScrollView = UIScrollView()

    /// Content view của scroll view.
    let contentView: UIView = UIView()

    /// Là custom view cho phần menu.
    let menuView: PagingMenuView

    // MARK: - Intializer

    init(settings: PagingMenuSettings = PagingMenuSettings()) {
        self.settings = settings
        self.menuView = PagingMenuView(settings: settings)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
        setupScrollView()
        setupFirstPageController()
    }

    private func shouldAddChildController(at index: Int) -> Bool {
        let child = dataSource.pagingViewController(self, pageControllerAt: index)
        return child.parent != self
    }
}

// ========================================================================= //
// ========================== Phien ban chinh sua ========================== //
// ========================================================================= //
//
// MARK: - UIScrollViewDelegate

extension PagingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.x
        let currentPageIndex = Int(round(currentOffset/pageWidth))
        let isSwipeRight = currentOffset > lastContentOffset

//        if swipeDirection == .undetermine {
//            swipeDirection = isSwipeRight ? .right : .left
//        }
        swipeDirection = isSwipeRight ? .right : .left
        print("DEBUG: direction before: \(swipeDirection)")

        var progress =  (currentOffset - lastContentOffset) / pageWidth
        if progress > 0 {
            progress = min(progress, 1)
        } else {
            progress = max(progress, -1)
        }

        if !isSelecting && isSwipeRight && progress != 1 {
            let fromIndex = Int(currentOffset/pageWidth)
            addMorePageController(fromIndex: fromIndex, toIndex: fromIndex + 1)
        }

        var indexJustChanged: Bool = false
        if currentIndex != currentPageIndex {
            currentIndex = currentPageIndex
            indexJustChanged = true
        }

        if swipeDirection == .right {
            let x = Int(floor(currentOffset/pageWidth))

            if x == currentPageIndex {
                lastContentOffset = CGFloat(currentPageIndex) * pageWidth
//                swipeDirection = .undetermine
            }
        } else if swipeDirection == .left {
            let x = Int(ceil(currentOffset/pageWidth))

            if x == currentPageIndex {
                lastContentOffset = CGFloat(currentPageIndex) * pageWidth
//                swipeDirection = .undetermine
            }
        }
        print("DEBUG: direction after: \(swipeDirection)")
        // Khi bấm vào menu item nó sẽ gọi lại method "scrollViewDidScroll" 1 lần.
        // Do đó cần update lại menuView khi và chỉ khi swipe hoặc scroll không phải select.
        if !isSelecting {
            menuView.didTransitioning(currentIndex: currentIndex, progress: progress, indexJustChanged: indexJustChanged)
            delegate?.pagingViewController(self, didTrasitioningAt: currentIndex, progress: progress, indexJustChanged: indexJustChanged)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        swipeDirection = .undetermine
        lastContentOffset = scrollView.contentOffset.x
        currentIndex = Int(lastContentOffset/pageWidth)
    }
}

// MARK: - DAPagingMenuViewDelegate

extension PagingViewController: PagingMenuViewDelegate {
    func pagingMenuView(_ pagingMenuView: PagingMenuView, didSelectItemAt index: Int) {
        isSelecting = true

        if shouldAddChildController(at: index) {
            addMorePageController(fromIndex: potentialNewIndex, toIndex: index)
        }

        let newContentOffset = (pageWidth + pageSpacing) * CGFloat(index)

        UIView.animate(withDuration: settings.transitionTimeInterval, delay: 0,
                       usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut]) {
            // Dòng code này sẽ trigger luôn method "scrollViewDidScroll",
            // và đợi nó return rồi mới gọi tiếp tới đoạn code sau.
            // Giúp cho "currentIndex" được đồng bộ theo mà không
            // cần phải thay đổi thủ công trong method này.
            self.scrollView.contentOffset.x = newContentOffset
        } completion: { _ in
            self.isSelecting = false
        }

        delegate?.pagingViewController(self, didSelectMenuItemAtIndex: index)
    }
}
//
// ========================================================================= //
// ========================== Phien ban chinh sua ========================== //
// ========================================================================= //


//extension DAPagingViewController: UIScrollViewDelegate {
//
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let currentOffset = scrollView.contentOffset.x
//    let fromIndex = currentIndex
//
//    // Ban đầu swipeDirection là undetermine cho đến khi method "scrollViewDidEndDragging"
//    // được gọi nên sẽ cần biến "isSwipeLeft" để xác định trước hướng swipe.
//    let isSwipeLeft = currentOffset > lastContentOffset
//    var toIndex: Int
//    switch swipeDirection {
//      case .left:
//        toIndex = currentIndex + 1
//      case .right:
//        toIndex = currentIndex - 1
//      case .undetermine:
//        toIndex = isSwipeLeft ? currentIndex + 1 : currentIndex - 1
//    }
//
//    guard toIndex >= 0 && toIndex < numberOfPages else { return }
//
//    // Nếu child controller chưa được add thì sẽ add.
//    // Lazy loading cho các child controller.
//    if !alreadyAddChildController(at: toIndex) {
//      let pageVC = dataSource.pagingViewController(self, pageControllerAt: toIndex)
//      let previousPageVC = dataSource.pagingViewController(self, pageControllerAt: currentIndex)
//      addPageController(pageVC, previousPageController: previousPageVC)
//    }
//
//    let progress = (currentOffset - lastContentOffset) / pageWidth
//    successfulTransition = (abs(progress) >= 0.5)
//
//    // Khi bấm vào menu item nó sẽ gọi lại method "scrollViewDidScroll" 1 lần.
//    // Do đó cần update lại menuView khi và chỉ khi swipe hoặc scroll không phải select.
//    if !isSelecting {
//      menuView.didTransitioning(fromIndex: fromIndex, toIndex: toIndex,
//                                progress: progress, indexWasChange: false, successful: successfulTransition)
//      delegate?.pagingViewController(self, isTrasitioning: fromIndex,
//                                     toIndex: toIndex, progress: progress,
//                                     success: successfulTransition)
//    }
//  }
//
//  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//    let currentOffset = scrollView.contentOffset.x
//    swipeDirection = currentOffset > lastContentOffset ? .left : .right
//  }
//
//  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    let currentOffset = scrollView.contentOffset.x
//    let fromIndex = currentIndex
//
//    var toIndex: Int
//    switch swipeDirection {
//      case .left:
//        toIndex = currentIndex + 1
//      case .right:
//        toIndex = currentIndex - 1
//      case .undetermine:
//        toIndex = currentIndex
//    }
//
//    guard toIndex >= 0 && toIndex < numberOfPages else { return }
//
//    menuView.didCompleteTransition(fromIndex: fromIndex, toIdex: toIndex,
//                                   successful: successfulTransition)
//
//    if successfulTransition {
//      updateDataAfterSuccessTransition(newIndex: toIndex, newContentOffset: currentOffset)
//    }
//
//    delegate?.pagingViewController(self, didCompleteTransitioning: fromIndex,
//                                   toIndex: toIndex, success: successfulTransition)
//  }
//
//  /// Update lại `currentIndex`, `lastContentOffset` và `swipeDirection` sau khi transition đã thành công.
//  private func updateDataAfterSuccessTransition(newIndex: Int, newContentOffset: CGFloat) {
//    currentIndex = newIndex
//    lastContentOffset = newContentOffset
//    swipeDirection = .undetermine
//  }
//
//}
//
////MARK: - DAPagingMenuViewDelegate
//extension DAPagingViewController: DAPagingMenuViewDelegate {
//  func pagingMenuView(_ pagingMenuView: DAPagingMenuView, didSelectItemAt index: Int) {
//    self.isSelecting = true
//    let newContentOffset = (pageWidth + pageSpacing) * CGFloat(index)
//
//    UIView.animate(withDuration: settings.transitionTimeInterval,
//                   delay: 0,
//                   usingSpringWithDamping: 1,
//                   initialSpringVelocity: 1,
//                   options: [.curveEaseInOut]) {
//      // Dòng code này sẽ trigger luôn method "scrollViewDidScroll",
//      // và đợi nó return rồi mới gọi tiếp tới đoạn code sau.
//      self.scrollView.contentOffset.x = newContentOffset
//    } completion: { _ in
//      self.isSelecting = false
//    }
//
//    updateDataAfterSuccessTransition(newIndex: index, newContentOffset: newContentOffset)
//    delegate?.pagingViewController(self, didSelectItemAt: index)
//  }
//}





// Trường hợp có page spacing

//extension DAPagingViewController: UIScrollViewDelegate {
//
//  /// - Note: Method này sẽ được gọi lại 1 lần sau khi `scrollViewDidEndDecelerating` đã được gọi
//  /// (i.e. sau khi scroll đã thực sự dừng, thì nó lại tư động scroll thêm 1 đoạn nữa).
//  /// Điều này xảy ra là do có spacing giữa của page view controller `pageSpacing`.
//  ///
//  func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    let currentOffset = scrollView.contentOffset.x
//    let fromIndex = currentIndex
//
//    // Ban đầu swipeDirection là undetermine cho đến khi method "scrollViewDidEndDragging"
//    // được gọi nên sẽ cần biến "isSwipeLeft" để xác định trước hướng swipe.
//    let isSwipeLeft = currentOffset > lastContentOffset
//
//    var toIndex: Int
//    switch swipeDirection {
//      case .left:
//        toIndex = currentIndex + 1
//      case .right:
//        toIndex = currentIndex - 1
//      case .undetermine:
//        toIndex = isSwipeLeft ? currentIndex + 1 : currentIndex - 1
//    }
//
//    guard toIndex >= 0 && toIndex < numberOfPages else {
//      return
//    }
//
//    // Nếu child controller chưa được add thì sẽ add.
//    // Lazy loading cho các child controller.
//    if !alreadyAddChildController(at: toIndex) {
//      let pageVC = dataSource.pagingViewController(self, pageControllerAt: toIndex)
//      let previousPageVC = dataSource.pagingViewController(self, pageControllerAt: currentIndex)
//      addPageController(pageVC, previousPageController: previousPageVC)
//    }
//
//    let progress = (currentOffset - lastContentOffset) / pageWidth
//    self.successfulTransition = (abs(progress) >= 0.5)
//
//    //    Trường hợp set pageSpacing
//        if !willAdjustContentOffsetAgain {
//          successfulTransition = abs(progress) > 0.5
//        } else {
//          willAdjustContentOffsetAgain = false
//        }
//
//    // Khi bấm vào menu item nó sẽ gọi lại method "scrollViewDidScroll" 1 lần.
//    // Do đó cần update lại menuView khi và chỉ khi swipe hoặc scroll không phải select.
//    if !isSelecting {
//      menuView.didTransitioning(fromIndex: currentIndex, toIndex: toIndex,
//                                progress: progress, successful: successfulTransition)
//      delegate?.pagingViewController(self, isTrasitioning: fromIndex,
//                                     toIndex: toIndex, progress: progress,
//                                     success: successfulTransition)
//    }
//  }
//
//  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//    let currentOffset = scrollView.contentOffset.x
//    swipeDirection = currentOffset > lastContentOffset ? .left : .right
//  }
//
//  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//    let currentOffset = scrollView.contentOffset.x
//    let fromIndex = currentIndex
//
//    var toIndex: Int
//    switch swipeDirection {
//      case .left:
//        toIndex = currentIndex + 1
//      case .right:
//        toIndex = currentIndex - 1
//        // Trường hợp set pageSpacing
//        // Khi bấm vào 1 page, nó sẽ giật giật và khi đó swipeDirection sẽ là undetermine.
//      case .undetermine:
//        toIndex = currentIndex
//    }
//
//    guard toIndex >= 0 && toIndex < numberOfPages else {
//      return
//    }
//
//    //    Trường hợp set pageSpacing
//        willAdjustContentOffsetAgain = shouldAdjustContentOffset ? true : false
//
//    menuView.didCompleteTransition(fromIndex: fromIndex, toIdex: toIndex,
//                                   successful: successfulTransition)
//
//    if self.successfulTransition {
//      updateDataAfterSuccessTransition(newIndex: toIndex, newContentOffset: currentOffset)
//    }
//
//    //    Trường hợp set pageSpacing
//            UIView.animate(withDuration: 0.2, delay: 0,
//                           usingSpringWithDamping: 1,
//                           initialSpringVelocity: 1,
//                           options: [.curveEaseInOut]) {
//              if self.shouldAdjustContentOffset {
//                let newOffset = CGPoint(x: self.scrollView.contentOffset.x + self.pageSpacing * CGFloat(self.currentIndex), y: 0)
//                self.scrollView.contentOffset.x += self.pageSpacing * CGFloat(self.currentIndex)
//                self.scrollView.setContentOffset(newOffset, animated: true)
//              }
//            }
//
//    self.swipeDirection = .undetermine
//    delegate?.pagingViewController(self, didCompleteTransitioning: fromIndex,
//                                   toIndex: toIndex, success: successfulTransition)
//  }
//
//  /// Update lại `currentIndex` và `lastContentOffset` sau khi transition đã thành công.
//  private func updateDataAfterSuccessTransition(newIndex: Int, newContentOffset: CGFloat) {
//    currentIndex = newIndex
//    lastContentOffset = newContentOffset
//  }
//}
