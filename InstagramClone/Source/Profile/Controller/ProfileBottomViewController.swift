//
//  ProfileBottomViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

class ProfileBottomViewController: UIViewController, BottomControllerProvider {
  
  // MARK: - BottomControllerProvider
  let menuItemHeight: CGFloat = 44
  
  var currentViewController: UIViewController {
    viewControllers[currentIndex]
  }
  
  weak var delegate: BottomControllerProviderDelegate?
  
  // MARK: - Properties
  var currentIndex: Int = 0
  
  private var pagingVC: PagingViewController!
  
  private let viewControllers = [
    ProfilePhotoDisplayController(collectionViewLayout: UICollectionViewFlowLayout()),
    ProfilePhotoDisplayController(collectionViewLayout: UICollectionViewFlowLayout()),
    ProfilePhotoDisplayController(collectionViewLayout: UICollectionViewFlowLayout())
  ]
  
  private let menuItems: [DefaultMenuItem] = [
    DefaultMenuItem(normalImage: UIImage(named: "gird_icon")!),
    DefaultMenuItem(normalImage: UIImage(named: "reels_icon")!),
    DefaultMenuItem(normalImage: UIImage(named: "tagged_icon")!),
  ]
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPagingVC()
  }
  
  private func setupPagingVC() {
    pagingVC = PagingViewController()
    pagingVC.menuItemSize = .fill(height: menuItemHeight)
    pagingVC.menuIndicatorHeight = 1.5
    pagingVC.menuSelectedColor = .darkGray
    
    pagingVC.dataSource = self
    pagingVC.delegate = self
    addChildController(pagingVC)
    pagingVC.view.pinToView(self.view)
  }
  
}

// MARK: - PagingViewControllerDataSource
extension ProfileBottomViewController: PagingViewControllerDataSource {
  
  func numberOfPageControllers(in pagingViewController: PagingViewController) -> Int {
    return viewControllers.count
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController,
                            pageControllerAt index: Int) -> UIViewController {
    return viewControllers[index]
  }
  
  func menuItems(in pagingViewController: PagingViewController) -> [DefaultMenuItem] {
    return menuItems
  }
  
}

// MARK: - PagingViewControllerDelegate
extension ProfileBottomViewController: PagingViewControllerDelegate {
  
  func pagingViewController(_ pagingViewController: PagingViewController,
                            isTrasitioning fromIndex: Int, toIndex: Int,
                            currentIndex: Int, progress: CGFloat,
                            indexWasChange: Bool, success: Bool) {
    if indexWasChange {
      self.currentIndex = currentIndex
      delegate?.bottomControllerProvider(self, currentViewController: currentViewController,
                                         currentIndex: currentIndex)
    }
  }
  
  func pagingViewController(_ pagingViewController: PagingViewController,
                            didSelectMenuItemAtIndex currentIndex: Int) {
    self.currentIndex = currentIndex
    delegate?.bottomControllerProvider(self, currentViewController: currentViewController,
                                       currentIndex: currentIndex)
  }
}
