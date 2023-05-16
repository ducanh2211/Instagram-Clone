//
//  MenuBottomIndicator.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 12/05/2023.
//

import UIKit

class MenuBottomIndicator: UICollectionReusableView {
  
  static var identifier: String { String(describing: self) }
  
  private let separatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let indicatorView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Properties
  var settings: PagingMenuSettings? {
    didSet { configure() }
  }
  
  var layout: UICollectionViewCompositionalLayout? {
    didSet {
      let itemSize = getItemSize(at: previousIndex)
      cachedItemSize[previousIndex] = itemSize
      indicatorWidthConstraint.constant = itemSize.width
    }
  }
  
  private var previousIndex: Int = 0
  private var previousOffsetConstant: CGFloat = 0
  private var cachedItemSize: [Int: CGSize] = [:]
  private var separatorHeightConstraint: NSLayoutConstraint!
  private var indicatorWidthConstraint: NSLayoutConstraint!
  private var indicatorHeightConstraint: NSLayoutConstraint!
  private var indicatorLeftConstraint: NSLayoutConstraint!
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  
  /// Update indicator view khi menu item được select.
  func adjustIndicatorPosition(withNewIndex newIndex: Int, completion: (() -> Void)? = nil) {
    var itemSize: CGSize
    
    if let cachedSize = cachedItemSize[newIndex] {
      itemSize = cachedSize
    } else {
      itemSize = getItemSize(at: newIndex)
      cachedItemSize[newIndex] = itemSize
    }
    
    let offsetConstant = CGFloat(newIndex - previousIndex) * itemSize.width
    indicatorLeftConstraint.constant += offsetConstant
    
    UIView.animate(withDuration: settings?.transitionTimeInterval ?? 0.25,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: [.curveEaseInOut]) {
      self.layoutIfNeeded()
    } completion: { _ in
      self.updateDataAfterSuccessfulTransition(newIndex: newIndex)
      completion?()
    }
  }
  
  /// Update indicator view khi menu item được scroll.
  private func adjustIndicatorPosition(withNewIndex newIndex: Int, progress: CGFloat) {
    var itemSize: CGSize
    
    if let cachedSize = cachedItemSize[newIndex] {
      itemSize = cachedSize
    } else {
      itemSize = getItemSize(at: newIndex)
      cachedItemSize[newIndex] = itemSize
    }
    
    let offsetConstant = CGFloat(newIndex - previousIndex) * itemSize.width * abs(progress)
    indicatorLeftConstraint.constant += (offsetConstant - previousOffsetConstant)
    previousOffsetConstant = offsetConstant
    
    UIView.animate(withDuration: settings?.transitionTimeInterval ?? 0.25,
                   delay: 0,
                   usingSpringWithDamping: 1,
                   initialSpringVelocity: 1,
                   options: [.curveEaseInOut]) {
      self.layoutIfNeeded()
    }
  }
  
  /// Update lại `previousIndex` và `previousOffsetConstant` sau khi transition thành công.
  private func updateDataAfterSuccessfulTransition(newIndex: Int) {
    self.previousIndex = newIndex
    self.previousOffsetConstant = 0
  }
  
  private func configure() {
    guard let settings = settings else { return }
    separatorView.backgroundColor = settings.separatorColor
    indicatorView.backgroundColor = settings.selectedColor
    indicatorHeightConstraint.constant = settings.indicatorHeight
    separatorHeightConstraint.constant = settings.separatorHeight
  }
  
  // MARK: - Helper
  private func getItemSize(at index: Int) -> CGSize {
    guard let layout = layout else { return .zero }
    let indexPath = IndexPath(item: index, section: 0)
    
    guard let attributes = layout.layoutAttributesForItem(at: indexPath) else { return .zero }
    return attributes.size
  }
  
  private func getItemFrame(at index: Int) -> CGRect {
    guard let layout = layout else { return .zero }
    let indexPath = IndexPath(item: index, section: 0)
    
    guard let attributes = layout.layoutAttributesForItem(at: indexPath) else { return .zero }
    return attributes.frame
  }
  
  private func setup() {
    addSubview(separatorView)
    addSubview(indicatorView)
    
    separatorHeightConstraint = separatorView.heightAnchor.constraint(equalToConstant: 1)
    indicatorLeftConstraint = indicatorView.leftAnchor.constraint(equalTo: leftAnchor)
    indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 1)
    indicatorHeightConstraint = indicatorView.heightAnchor.constraint(equalToConstant: 1)
    
    NSLayoutConstraint.activate([
      separatorView.leftAnchor.constraint(equalTo: leftAnchor),
      separatorView.rightAnchor.constraint(equalTo: rightAnchor),
      separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorHeightConstraint,
      
      indicatorLeftConstraint,
      indicatorView.topAnchor.constraint(equalTo: topAnchor),
      indicatorView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
      indicatorWidthConstraint,
      indicatorHeightConstraint
    ])
  }
  
}

// MARK: - DAPagingMenuUpdatable
extension MenuBottomIndicator: PagingMenuUpdatable {
  func didTransitioning(fromIndex: Int, toIndex: Int, progress: CGFloat, indexWasChange: Bool, success: Bool) {
    adjustIndicatorPosition(withNewIndex: toIndex, progress: progress)
  }
  
  func didCompleteTransition(fromIndex: Int, toIdex: Int, success: Bool) {
    if success {
      updateDataAfterSuccessfulTransition(newIndex: toIdex)
    }
  }
  
}


