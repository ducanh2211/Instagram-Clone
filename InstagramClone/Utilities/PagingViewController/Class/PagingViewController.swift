//
//  PagingViewController.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

class PagingViewController: UIViewController {
  
  // MARK: - Public properties
  var menuItemSize: MenuItemSize {
    get { settings.itemSize }
    set { settings.itemSize = newValue }
  }
  
  var menuIndicatorHeight: CGFloat {
    get { settings.indicatorHeight }
    set { settings.indicatorHeight = newValue }
  }
  
  var menuSeparatorHeight: CGFloat {
    get { settings.separatorHeight }
    set { settings.separatorHeight = newValue }
  }
  
  var menuSeparatorColor: UIColor {
    get { settings.separatorColor }
    set { settings.separatorColor = newValue }
  }
  
  var menuNormalColor: UIColor {
    get { settings.normalColor }
    set { settings.normalColor = newValue }
  }
  
  var menuSelectedColor: UIColor {
    get { settings.selectedColor }
    set { settings.selectedColor = newValue }
  }
  
  var menuNormalFont: UIFont {
    get { settings.normalFont }
    set { settings.normalFont = newValue }
  }
  
  var menuSelectedFont: UIFont {
    get { settings.selectedFont }
    set { settings.selectedFont = newValue }
  }
  
  var transitionTimeInterval: TimeInterval {
    get { settings.transitionTimeInterval }
    set { settings.transitionTimeInterval = newValue }
  }
  
  weak var dataSource: PagingViewControllerDataSource!
  weak var delegate: PagingViewControllerDelegate?
  
  // MARK: - Private properties
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
  
  /// Có cần thay đổi content offset sau khi scroll đã dừng i.e. "scrollViewDidEndDecelerating" được gọi.
  /// Cần phải có nếu như set `controllerSpacing` khác 0.
  /// `False` khi scroll quá contentSize của scroll view.
  //  private var shouldAdjustContentOffset: Bool {
  //    (scrollView.contentOffset.x >= 0) &&
  //    (scrollView.contentOffset.x <= pageWidth * CGFloat((numberOfPages - 1)))
  //  }
  
  /// Sẽ thay đổi content offset sau khi scroll đã dừng. i.e. "scrollViewDidScroll" sẽ được gọi lại.
  /// `True` khi content offset sẽ bị thay đổi sau khi "scrollViewDidEndDecelerating" được gọi.
  /// Cần phải có nếu như set `controllerSpacing` khác 0.
  //  private var willAdjustContentOffsetAgain: Bool = false
  
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
  
  private(set) var settings: PagingMenuSettings {
    didSet { menuView.settings = settings }
  }
  
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
    let isSwipeLeft = currentOffset > lastContentOffset
    let fromIndex = potentialNewIndex
    
    var toIndex: Int
    switch swipeDirection {
      case .left:
        toIndex = fromIndex + 1
      case .right:
        toIndex = fromIndex - 1
      case .undetermine:
        toIndex = isSwipeLeft ? fromIndex + 1 : fromIndex - 1
    }

    guard toIndex >= 0 && toIndex < numberOfPages else { return }

    let progress = (currentOffset - lastContentOffset) / pageWidth
    successfulTransition = (abs(progress) >= 0.5)

    var indexWasChange: Bool = false
    if currentIndex != currentPageIndex {
      currentIndex = currentPageIndex
      indexWasChange = true
    }

    // Khi bấm vào menu item nó sẽ gọi lại method "scrollViewDidScroll" 1 lần.
    // Do đó cần update lại menuView khi và chỉ khi swipe hoặc scroll không phải select.
    if !isSelecting {
      // Nếu child controller chưa được add thì sẽ add. Lazy loading cho các child controller.
      if shouldAddChildController(at: toIndex) {
        addMorePageController(fromIndex: fromIndex, toIndex: toIndex)
      }
      
      menuView.didTransitioning(fromIndex: fromIndex,
                                toIndex: toIndex,
                                progress: progress,
                                indexWasChange: indexWasChange,
                                success: successfulTransition)
      
      delegate?.pagingViewController(self, isTrasitioning: fromIndex, toIndex: toIndex,
                                     currentIndex: currentIndex, progress: progress,
                                     indexWasChange: indexWasChange, success: successfulTransition)
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffset = scrollView.contentOffset.x
    swipeDirection = currentOffset > lastContentOffset ? .left : .right
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.x
    let fromIndex: Int = potentialNewIndex
    
    var toIndex: Int
    switch swipeDirection {
      case .left:
        toIndex = potentialNewIndex + 1
      case .right:
        toIndex = potentialNewIndex - 1
      case .undetermine:
        toIndex = potentialNewIndex
    }
    swipeDirection = .undetermine
    
    guard toIndex >= 0 && toIndex < numberOfPages else { return }

    menuView.didCompleteTransition(fromIndex: fromIndex, toIdex: toIndex,
                                   success: successfulTransition)
    delegate?.pagingViewController(self, didCompleteTransitioning: fromIndex,
                                   toIndex: toIndex, success: successfulTransition)

    if successfulTransition {
      updateDataAfterSuccessTransition(newIndex: toIndex, newContentOffset: currentOffset)
    }
  }

  private func updateDataAfterSuccessTransition(newIndex: Int, newContentOffset: CGFloat) {
    potentialNewIndex = newIndex
    lastContentOffset = newContentOffset
  }
}

extension PagingViewController: DAPagingMenuViewDelegate {
  func pagingMenuView(_ pagingMenuView: PagingMenuView, didSelectItemAt index: Int) {
    isSelecting = true
    
    if shouldAddChildController(at: index) {
      addMorePageController(fromIndex: potentialNewIndex, toIndex: index)
    }
    
    let newContentOffset = (pageWidth + pageSpacing) * CGFloat(index)

    UIView.animate(withDuration: settings.transitionTimeInterval,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: [.curveEaseInOut]) {
      // Dòng code này sẽ trigger luôn method "scrollViewDidScroll",
      // và đợi nó return rồi mới gọi tiếp tới đoạn code sau.
      // Giúp cho "currentIndex" được đồng bộ theo mà không
      // cần phải thay đổi thủ công trong method này.
      self.scrollView.contentOffset.x = newContentOffset
    } completion: { _ in
      self.isSelecting = false
    }

    updateDataAfterSuccessTransition(newIndex: index, newContentOffset: newContentOffset)
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
