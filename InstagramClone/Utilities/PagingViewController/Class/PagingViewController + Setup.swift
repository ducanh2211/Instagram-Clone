//
//  DAPagingViewController + Setup.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 13/05/2023.
//

import UIKit

// MARK: - Set up
extension PagingViewController {
  
  func setupScrollView() {
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.bounces = true
    scrollView.delegate = self
    scrollView.contentInsetAdjustmentBehavior = .never
    scrollView.isDirectionalLockEnabled = true
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    let contentGuide = scrollView.contentLayoutGuide
    let frameGuide = scrollView.frameLayoutGuide
    
    NSLayoutConstraint.activate([
      scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
      scrollView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
      scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
   
      contentView.leftAnchor.constraint(equalTo: contentGuide.leftAnchor),
      contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
      contentView.rightAnchor.constraint(equalTo: contentGuide.rightAnchor),
      contentView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
      contentView.heightAnchor.constraint(equalTo: frameGuide.heightAnchor)
    ])
  }
  
  func setupMenuView() {
    menuView.menuItems = dataSource.menuItems(in: self)
    menuView.delegate = self
    
    view.addSubview(menuView)
    menuView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      menuView.leftAnchor.constraint(equalTo: view.leftAnchor),
      menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      menuView.rightAnchor.constraint(equalTo: view.rightAnchor),
      menuView.heightAnchor.constraint(equalToConstant: settings.itemSize.menuHeight)
    ])
  }
  
  func setupFirstPageController() {
    let frameGuide = scrollView.frameLayoutGuide
    let numberOfPages = dataSource.numberOfPageControllers(in: self)
    let remainSpacing = CGFloat(numberOfPages - 1) * (pageWidth + pageSpacing)
    
    let pageController = dataSource.pagingViewController(self, pageControllerAt: 0)
    pageController.view.translatesAutoresizingMaskIntoConstraints = false
    addChildController(pageController, toView: contentView)
    
    NSLayoutConstraint.activate([
      pageController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      pageController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
      pageController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -remainSpacing),
      pageController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      pageController.view.widthAnchor.constraint(equalTo: frameGuide.widthAnchor),
    ])
  }
  
  func addMorePageController(fromIndex: Int, toIndex: Int) {
    let frameGuide = scrollView.frameLayoutGuide
    var previousPageController = dataSource.pagingViewController(self, pageControllerAt: fromIndex)

    for index in (fromIndex + 1)...toIndex {
      let pageController = dataSource.pagingViewController(self, pageControllerAt: index)
      pageController.view.translatesAutoresizingMaskIntoConstraints = false
      addChildController(pageController, toView: contentView)
      
      NSLayoutConstraint.activate([
        pageController.view.leftAnchor.constraint(equalTo: previousPageController.view.rightAnchor, constant: pageSpacing),
        pageController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
        pageController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        pageController.view.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
      ])
      
      previousPageController = pageController
    }
  }
  
}
