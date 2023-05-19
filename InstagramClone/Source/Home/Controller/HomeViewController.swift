//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

extension HomeViewController {
  enum HomeSection: Int, CaseIterable {
    case story
    case post
  }
}

// MARK: - HomeViewController
class HomeViewController: UIViewController {
  
  // MARK: - Properties
  var collectionView: UICollectionView!
  var navBar: CustomNavigationBar!
  
  var fakeView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBackground
    return view
  }()
  
  private let viewModel: HomeViewModel
  private var lastContentOffset: CGFloat = 0
  let navBarHeight: CGFloat = 44
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupView()
  }
  
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    HomeSection.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    if HomeSection(rawValue: section) == .story { return 10 }
    return 6
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if HomeSection(rawValue: indexPath.section) == .story {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomeStoryCell.identifier,
        for: indexPath) as! HomeStoryCell
      
      return cell
    }
    
    else {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: HomePostCell.identifier,
        for: indexPath) as! HomePostCell
      
      return cell
    }
  }
  
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard scrollView == collectionView else { return }
    let currentOffset = scrollView.contentOffset.y
    
    if currentOffset < 0 {
      lastContentOffset = 0
      return
    }
    if currentOffset > scrollView.contentSize.height {
      lastContentOffset = scrollView.contentSize.height
      return
    }
    
    if currentOffset > lastContentOffset {
      UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut) {
        self.navBar.transform = CGAffineTransform(translationX: 0, y: -self.navBarHeight)
      }
    }
    else {
      UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut) {
        self.navBar.transform = .identity
      }
    }
    
    lastContentOffset = currentOffset
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    
    if currentOffset == 0 {
      UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseInOut) {
        self.navBar.transform = .identity
      }
    }
    
    lastContentOffset = currentOffset
  }
  
}
