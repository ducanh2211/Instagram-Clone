//
//  TabBarViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
import FirebaseAuth

class TabBarViewController: UITabBarController {
  
  var user: User? {
    didSet {
      feedVC.user = user
    }
  }
  
  private let feedVC = FeedViewController()
  private let searchVC = SearchViewController()
  private let postVC = PostViewController()
  private let profileVC = ProfileViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.tabBar.isTranslucent = false
    self.tabBar.tintColor = .label
    logout()
    validateUser()
  }
  
  func validateUser() {
    if Auth.auth().currentUser == nil {
      presentLoginController()
    } else {
      setupController()
    }
  }
  
  func logout() {
    try? Auth.auth().signOut()
  }
  
  private func fetchUser() {
    
  }
  
  private func presentLoginController() {
    DispatchQueue.main.async {
      let nav = UINavigationController(rootViewController: LogInViewController())
      nav.modalPresentationStyle = .fullScreen
      self.present(nav, animated: false)
    }
  }
  
  private func setupController() {
    let feedNav = createController(
      feedVC,
      selectedImage: UIImage(systemName: "house.fill"),
      unselectedImage: UIImage(systemName: "house")
    )
    let searchNav = createController(
      searchVC,
      selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"),
      unselectedImage: UIImage(systemName: "magnifyingglass.circle")
    )
    let postNav = createController(
      postVC,
      selectedImage: UIImage(systemName: "plus.app.fill"),
      unselectedImage: UIImage(systemName: "plus.app")
    )
    let profileNav = createController(
      profileVC,
      selectedImage: UIImage(systemName: "person.circle.fill"),
      unselectedImage: UIImage(systemName: "person.circle")
    )
    self.viewControllers = [feedNav, searchNav, postNav, profileNav]
  }
  
  private func createController(_ rootViewController: UIViewController,
                                selectedImage: UIImage?,
                                unselectedImage: UIImage?) -> UINavigationController {
    
    let nav = UINavigationController(rootViewController: rootViewController)
    nav.tabBarItem.selectedImage = selectedImage
    nav.tabBarItem.image = unselectedImage
    return nav
  }
}
