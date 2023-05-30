//
//  ProfileController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
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

    var currentUser: User {
        didSet {
            headerVC.currentUser = currentUser
            bottomVC.currentUser = currentUser
        }
    }
    var otherUser: User?
    var isLoggedInUser: Bool {
        return otherUser == nil
    }

    // MARK: - Initializer

    init(currentUser: User, otherUser: User?) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        headerViewController = ProfileHeaderController(currentUser: currentUser, otherUser: otherUser)
        bottomViewController =  ProfileBottomController(currentUser: currentUser, otherUser: otherUser)
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
        headerVC.delegate = self
        setupView()
    }

    // MARK: - Functions

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
        let vc = LogInViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
}

// MARK: - ProfileHeaderViewControllerDelegate

extension ProfileController: ProfileHeaderControllerDelegate {
    func didTapFollowOrEditButton() {
        if isLoggedInUser {
            editButtonTapped()
        }
    }

    private func editButtonTapped() {
        let vc = ProfileEditController(user: currentUser)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    func didTapMessageOrShareButton() { }
}

// MARK: - ProfileEditControllerDelegate

extension ProfileController: ProfileEditControllerDelegate {

    func userInfoDidChange() {
        self.fetchUser()
    }

    private func fetchUser() {
        UserManager.shared.fetchUser(withUid: currentUser.uid) { user, error in
            DispatchQueue.main.async {
                guard let user = user, error == nil else {
                    print("DEBUG: fetchUserAgain error: \(error!)")
                    return
                }
                self.currentUser = user
            }
        }
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

        if isLoggedInUser {
            let titleButton = AttributedButton(title: currentUser.userName,
                                               font: .systemFont(ofSize: 24, weight: .bold), color: .label) { [weak self] in
                self?.didTapTitleButton()
            }

            let settingsButton = AttributedButton(image: UIImage(systemName: "line.3.horizontal", withConfiguration: weight)!) { [weak self] in
                self?.didTapSettingsButton()
            }
            let createButton = AttributedButton(image: UIImage(systemName: "plus.app", withConfiguration: weight)!) { [weak self] in
                self?.didTapCreateButton()
            }

            navBar = CustomNavigationBar(shouldShowSeparator: false,
                                         leftBarButtons: [titleButton],
                                         rightBarButtons: [settingsButton, createButton])
        }
        else {
            let backButton = AttributedButton(image: UIImage(systemName: "chevron.backward", withConfiguration: weight)!) { [weak self] in
                self?.didTapBackButton()
            }
            let rightButton = AttributedButton(image: UIImage(systemName: "ellipsis")!)
            navBar = CustomNavigationBar(title: otherUser!.userName, shouldShowSeparator: false,
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
