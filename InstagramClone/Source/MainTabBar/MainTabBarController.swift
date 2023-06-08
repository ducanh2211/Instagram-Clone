//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    let viewModel: TabBarViewModel

    // MARK: - Life cycle
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEBUG: MainTabBarController deinit")
    }
    var time: Date!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemBackground
        tabBar.isHidden = true
        delegate = self
        time = Date()
        bindViewModel()
        validateUser()
    }

    // MARK: - Functions

    private func bindViewModel() {
        viewModel.receivedUser = { [weak self] in
            self?.setupController()
        }
    }

    func validateUser() {
        viewModel.userAlreadyLogIn ? setupController() : presentLoginController()
    }

    private func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LogInViewController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false)
        }
    }
}

// MARK: - Setup

extension MainTabBarController {
    private func setupController() {
        guard let user = self.viewModel.user else { return }
        print("DEBUG: time \(Date().timeIntervalSince(time))")
        let homeNav = setupHome(user: user)
        let searchNav = setupExplore(user: user)
        let postNav = setupPost()
        let reelsNav = setupReels()
        let profileNav = setupProfile(user: user)
        tabBar.isHidden = false
        setViewControllers([homeNav, searchNav, postNav, reelsNav, profileNav], animated: false)
    }

    private func setupHome(user: User) -> UINavigationController {
        let homeViewModel = HomeViewModel(currentUser: user)
        let homeVC = HomeController(viewModel: homeViewModel)
        let homeNav = createController(
            homeVC,
            selectedImage: UIImage(named: "home-selected"),
            unselectedImage: UIImage(named: "home-unselected")
        )
        return homeNav
    }

    private func setupExplore(user: User) -> UINavigationController {
        let searchViewModel = ExploreViewModel(currentUser: user)
        let searchVC = ExploreController(viewModel: searchViewModel)
        let searchNav = createController(
            searchVC,
            selectedImage: UIImage(named: "search-selected"),
            unselectedImage: UIImage(named: "search-unselected")
        )
        return searchNav
    }

    private func setupPost() -> UINavigationController {
        let postNav = createController(
            UIViewController(),
            selectedImage: UIImage(systemName: "plus.app.fill"),
            unselectedImage: UIImage(systemName: "plus.app")
        )
        return postNav
    }

    private func setupReels() -> UINavigationController {
        let reelsNav = createController(
            UIViewController(),
            selectedImage: UIImage(named: "reels-selected"),
            unselectedImage: UIImage(named: "reels-selected")
        )
        return reelsNav
    }

    private func setupProfile(user: User) -> UINavigationController {
        let profileViewModel = ProfileViewModel(type: .mainTabBar(currentUser: user))
        let profileVC = ProfileController(viewModel: profileViewModel)
        let profileNav = createController(
            profileVC,
            selectedImage: UIImage(systemName: "person.circle.fill"),
            unselectedImage: UIImage(systemName: "person.circle")
        )
        return profileNav
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

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {

        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return true }

        if index == 2 {
            let nav = UINavigationController(rootViewController: PhotoSelectorController())
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            return false
        }
        return true
    }
}
