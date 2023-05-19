//
//  TabBarViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {
  
  private(set) var viewModel: TabBarViewModel
  
  //  private let feedVC = HomeViewController()
  private let searchVC = SearchViewController()
  private let postVC = PostViewController()
  private let profileVC = ProfileViewController()
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.tabBar.isTranslucent = false
    self.tabBar.tintColor = .label
    self.delegate = self
//        logout()
    bindViewModel()
    validateUser()
  }
  
  init(viewModel: TabBarViewModel) {
    print("DEBUG: init tab bar VC")
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  private func bindViewModel() {
    print("DEBUG: Bind VIew Model")
    viewModel.receivedUser = { [weak self] in
      print("DEBUG: Bind view model completion")
      DispatchQueue.main.async {
        self?.setupController()
      }
    }
  }
  
  func validateUser() {
    viewModel.isUserAlreadyLogIn ? setupController() : presentLoginController()
  }
  
  func logout() {
    try? Auth.auth().signOut()
  }
  
  private func presentLoginController() {
    DispatchQueue.main.async {
      let nav = UINavigationController(rootViewController: LogInViewController())
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: false)
    }
  }
  
}

// MARK: - UI Layout
extension TabBarViewController {
  private func setupController() {
    guard let user = self.viewModel.user else { return }
    
    let feedViewModel = HomeViewModel(user: user)
    let feedVC = HomeViewController(viewModel: feedViewModel)
    
    let feedNav = self.createController(
      feedVC,
      selectedImage: UIImage(systemName: "house.fill"),
      unselectedImage: UIImage(systemName: "house")
    )
    let searchNav = self.createController(
      self.searchVC,
      selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"),
      unselectedImage: UIImage(systemName: "magnifyingglass.circle")
    )
    let postNav = self.createController(
      UIViewController(),
      selectedImage: UIImage(systemName: "plus.app.fill"),
      unselectedImage: UIImage(systemName: "plus.app")
    )
    let profileNav = self.createController(
      self.profileVC,
      selectedImage: UIImage(systemName: "person.circle.fill"),
      unselectedImage: UIImage(systemName: "person.circle")
    )
    self.viewControllers = [feedNav, searchNav, postNav, profileNav]
  }
  
  private func createController(_ rootViewController: UIViewController,
                                selectedImage: UIImage?,
                                unselectedImage: UIImage?) -> UINavigationController {
    
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.navigationBar.isTranslucent = true
    nav.tabBarItem.selectedImage = selectedImage
    nav.tabBarItem.image = unselectedImage
    return nav
  }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController,
                        shouldSelect viewController: UIViewController) -> Bool {
    
    guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }
    
    if index == 2 {
      let vc = PhotoSelectorViewController()
      let nav = UINavigationController(rootViewController: vc)
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: true)
      return false
    }
    
    return true
  }
}
