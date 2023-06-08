//
//  ProfileController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
import SDWebImage
import FirebaseAuth

class ProfileController: UIViewController, ContainerScrollViewDatasource, CustomizableNavigationBar {

    // MARK: - ContainerScrollViewDatasource

    let minHeaderViewHeight: CGFloat = 0
    let headerViewController: UIViewController
    let bottomViewController: BottomControllerProvider

    // MARK: - Properties

    var navBar: CustomNavigationBar!
    var containerScrollView: ContainerScrollViewController!
    private var headerVC: ProfileHeaderController {
        return headerViewController as! ProfileHeaderController
    }
    private var bottomVC: ProfileBottomController {
        return bottomViewController as! ProfileBottomController
    }
    var viewModel: ProfileViewModel


    // MARK: - Initializer

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        let headerViewModel = ProfileHeaderViewModel(user: viewModel.otherUser ?? viewModel.currentUser,
                                                     isCurrentUser: viewModel.isCurrentUser)
        let bottomViewModel = ProfileBottomViewModel(currentUser: viewModel.currentUser,
                                                     otherUser: viewModel.otherUser)
        self.headerViewController = ProfileHeaderController(viewModel: headerViewModel)
        self.bottomViewController = ProfileBottomController(viewModel: bottomViewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEBUG: ProfileController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        headerVC.delegate = self
    }

    // MARK: - Functions

    private func bindViewModel() {
        viewModel.fetchCurrentUserSuccess = { [weak self] in
            guard let self = self else { return }
            self.navBar.leftBarButtonItems[0].setTitle(self.viewModel.currentUser.userName, for: .normal)
            NotificationCenter.default.post(name: .currentUserDidUpdateInfo, object: nil,
                                            userInfo: ["currentUser": self.viewModel.currentUser])
        }
    }

    private func didTapSettingsButton() {
        let vc = ProfileSettingsSheetController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false) {
            vc.showSheet()
        }
    }

    private func didTapCreateButton() {
        let vc = ProfileCreateSheetController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false) {
            vc.showSheet()
        }
    }

    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private func didTapTitleButton() {
        let actionSheet = UIAlertController(title: "Do you want to log out?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let logoutAction = UIAlertAction(title: "Log out", style: .destructive) { [weak self] _ in
            self?.logout()
        }
        actionSheet.addAction(logoutAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }

    private func logout() {
        try? Auth.auth().signOut()
        SDImageCache.shared.clearMemory()
        let nav = UINavigationController(rootViewController: LogInViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - ProfileHeaderControllerDelegate

extension ProfileController: ProfileHeaderControllerDelegate {
    func didTapEditProfileButton() {
        if viewModel.isCurrentUser {
            editButtonTapped()
        }
    }

    private func editButtonTapped() {
        let vc = ProfileEditController(user: viewModel.currentUser)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    func didTapFollowersLabel() {
        let user = viewModel.otherUser ?? viewModel.currentUser
        let vc = FollowersDetailController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapFollowingLabel() {
        let user = viewModel.otherUser ?? viewModel.currentUser
        let vc = FollowingDetailController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapMessageOrShareButton() { }
}

// MARK: - ProfileEditControllerDelegate

extension ProfileController: ProfileEditControllerDelegate {
    func userInfoDidChange(newUser: User) {
        viewModel.fetchCurrentUser()
    }
}

// MARK: - Setup

extension ProfileController {
    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupContainerScrollView()
        setupConstraints()
    }

    private func setupNavBar() {
        let weight = UIImage.SymbolConfiguration(weight: .medium)

        switch viewModel.type {
            case .mainTabBar:
                let titleButton = AttributedButton(title: viewModel.currentUser.userName, font: .systemFont(ofSize: 24, weight: .bold), color: .label) { [weak self] in
                    self?.didTapTitleButton()
                }

                let settingsImage = UIImage(systemName: "line.3.horizontal", withConfiguration: weight)!
                let settingsButton = AttributedButton(image: settingsImage) { [weak self] in
                    self?.didTapSettingsButton()
                }

                let createImage = UIImage(systemName: "plus.app", withConfiguration: weight)!
                let createButton = AttributedButton(image: createImage) { [weak self] in
                    self?.didTapCreateButton()
                }

                navBar = CustomNavigationBar(shouldShowSeparator: false,
                                             leftBarButtons: [titleButton],
                                             rightBarButtons: [settingsButton, createButton])

            case .other(let currentUser, let otherUser):
                let backImage = UIImage(systemName: "chevron.backward", withConfiguration: weight)!
                let backButton = AttributedButton(image: backImage) { [weak self] in
                    self?.didTapBackButton()
                }

                let rightButton = AttributedButton(image: UIImage(systemName: "ellipsis")!)
                let title = otherUser?.userName ?? currentUser.userName

                navBar = CustomNavigationBar(title: title, shouldShowSeparator: false,
                                             leftBarButtons: [backButton], rightBarButtons: [rightButton])
        }
    }

    private func setupContainerScrollView() {
        containerScrollView = ContainerScrollViewController()
        containerScrollView.dataSource = self
        addChildController(containerScrollView)
    }

    private func setupConstraints() {
        view.addSubview(navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        containerScrollView.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            containerScrollView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerScrollView.view.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            containerScrollView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerScrollView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
