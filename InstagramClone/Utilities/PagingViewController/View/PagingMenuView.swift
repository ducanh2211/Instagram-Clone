//
//  DAPagingMenu.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

// MARK: - Protocol
protocol DAPagingMenuViewDelegate: AnyObject {
  /// Dùng để update transition khi menu item được select.
  /// - Parameters:
  ///   - pagingMenuView: menu view.
  ///   - index: index của item được select.
  func pagingMenuView(_ pagingMenuView: PagingMenuView, didSelectItemAt index: Int)
}

// MARK: - PagingMenuView
class PagingMenuView: UIView {
  
  var collectionView: UICollectionView!
  private var footerView: MenuBottomIndicator!
  
  // MARK: - Properties
  var menuItems: [DefaultMenuItem] = [] {
    didSet { menuItemsDidSet() }
  }
  
  private var layout: UICollectionViewCompositionalLayout {
    let manager = PagingMenuCollectionViewLayout(numberOfItems: numberOfItems, settings: settings)
    return manager.createLayout()
  }
  
  /// Mặc dù settings sẽ được set lại rất nhiều lần do user config Menu, trong đó có cả thay đổi collection view layout.
  /// Nhưng không cần thiết phải set lại layout.
  /// Bởi vì `menuItems` didSet sẽ set lại layout và nó sẽ được gọi sau khi `settings` đã config xong.
  /// Nên "chắc chắn" rằng layout sẽ được update.
  var settings: PagingMenuSettings
  weak var delegate: DAPagingMenuViewDelegate?
  
  /// Fake số lượng item ban đầu, số lượng thực tế sẽ có sau khi `menuItems` didSet.
  private var numberOfItems: Int = 1
  private var currentIndex: Int = 0
  private var cachedItemSize: [Int: CGSize] = [:]
  
  // MARK: - Initializer
  init(settings: PagingMenuSettings) {
    self.settings = settings
    super.init(frame: .zero)
    setupCollectionView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  
  /// Update property `isSelected` của `selected cell` và `previous cell` để nó có thể tự configure appearence.
  private func updateCellState(atIndex: Int, previousIndex: Int) {
    let selectedCell = collectionView.cellForItem(at: IndexPath(item: atIndex, section: 0))
    let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0))
    selectedCell?.isSelected = true
    previousCell?.isSelected = false
  }
  
  /// Update lại `currentIndex` sau khi transition thành công.
  private func updateDataAfterSuccessTransition(newIndex: Int) {
    currentIndex = newIndex
  }
  
  // MARK: - Helper
  private func menuItemsDidSet() {
    numberOfItems = menuItems.count
    collectionView.setCollectionViewLayout(layout, animated: true)
    collectionView.reloadData()
    collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                              animated: false, scrollPosition: .centeredHorizontally)
  }
  
  private func setupCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    addSubview(collectionView)
    collectionView.pinToView(self)
    
    collectionView.bounces = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.register(
      DefaultPagingMenuCell.self,
      forCellWithReuseIdentifier: DefaultPagingMenuCell.identifier
    )
    collectionView.register(
      MenuBottomIndicator.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: MenuBottomIndicator.identifier
    )
  }

}

// MARK: - DAPagingMenuViewUpdatable
extension PagingMenuView: PagingMenuUpdatable {
  
  func didTransitioning(fromIndex: Int, toIndex: Int,
                        progress: CGFloat, indexWasChange: Bool, success: Bool) {

    footerView.didTransitioning(fromIndex: fromIndex, toIndex: toIndex,
                                progress: progress, indexWasChange: indexWasChange, success: success)
    if indexWasChange {
      let atIndex: Int = success ? toIndex : fromIndex
      let previousIndex: Int = success ? fromIndex : toIndex
      updateCellState(atIndex: atIndex, previousIndex: previousIndex)
    }
  }
  
  func didCompleteTransition(fromIndex: Int, toIdex: Int, success: Bool) {
    footerView.didCompleteTransition(fromIndex: fromIndex, toIdex: toIdex, success: success)
    if success {
      updateDataAfterSuccessTransition(newIndex: toIdex)
    }
  }
  
}

// MARK: - UICollectionViewDelegate
extension PagingMenuView: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      shouldSelectItemAt indexPath: IndexPath) -> Bool {
    let newIndex = indexPath.item
    if currentIndex == newIndex { return false }
    return true
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let newIndex = indexPath.item
    let previousIndex = currentIndex
    collectionView.isUserInteractionEnabled = false

    footerView.adjustIndicatorPosition(withNewIndex: newIndex, completion: {
      collectionView.isUserInteractionEnabled = true
    })
    
    delegate?.pagingMenuView(self, didSelectItemAt: newIndex)
    didCompleteTransition(fromIndex: previousIndex, toIdex: newIndex, success: true)
    updateDataAfterSuccessTransition(newIndex: newIndex)
    updateCellState(atIndex: newIndex, previousIndex: previousIndex)
  }
  
}


// MARK: - UICollectionViewDataSource
extension PagingMenuView: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: DefaultPagingMenuCell.identifier,
      for: indexPath) as! DefaultPagingMenuCell
    let menuItem = menuItems[indexPath.item]
    cell.configurePagingCell(with: menuItem)
    cell.settings = settings
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    if kind == UICollectionView.elementKindSectionFooter {
      let footer = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: MenuBottomIndicator.identifier,
        for: indexPath) as! MenuBottomIndicator
      footerView = footer
      footer.settings = settings
      
      let layout = (collectionView.collectionViewLayout) as? UICollectionViewCompositionalLayout
      footer.layout = layout
      return footer
    }
    return UICollectionReusableView()
  }
  
}
