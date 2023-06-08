//
//  ProfileBottomViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

class ProfileBottomController: UIViewController, BottomControllerProvider {

    // MARK: - BottomControllerProvider

    let menuItemHeight: CGFloat = 44
    weak var delegate: BottomControllerProviderDelegate?
    var currentViewController: UIViewController {
        viewControllers[currentIndex]
    }

    // MARK: - Properties

    var currentIndex: Int = 0
    private var pagingVC: PagingViewController!
    private let viewControllers: [ProfilePhotoDisplayController]
    private let menuItems: [DefaultMenuItem]
    var viewModel: ProfileBottomViewModel

    // MARK: - Life cycle

    init(viewModel: ProfileBottomViewModel) {
        self.viewModel = viewModel
        self.viewControllers = [
            .init(viewModel: ProfilePhotoDisplayViewModel(currentUser: viewModel.currentUser, otherUser: viewModel.otherUser)),
            .init(viewModel: ProfilePhotoDisplayViewModel(currentUser: viewModel.currentUser, otherUser: viewModel.otherUser)),
            .init(viewModel: ProfilePhotoDisplayViewModel(currentUser: viewModel.currentUser, otherUser: viewModel.otherUser)),
        ]
        self.menuItems = [
            .init(normalImage: UIImage(named: "grid-unselected")!,
                  selectedImage: UIImage(named: "grid-selected")!),
            .init(normalImage: UIImage(named: "reels-unselected")!,
                  selectedImage: UIImage(named: "reels-selected")!),
            .init(normalImage: UIImage(named: "tagged-unselected")!,
                  selectedImage: UIImage(named: "tagged-selected")!),
        ]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .currentUserDidUpdateInfo, object: nil)
        print("DEBUG: ProfileBottomController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagingVC()
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidUpdateInfo),
                                               name: .currentUserDidUpdateInfo, object: nil)
    }

    private func reloadData() {
        viewControllers.forEach { controller in
            controller.viewModel = ProfilePhotoDisplayViewModel(currentUser: viewModel.currentUser,
                                                                otherUser: viewModel.otherUser)
        }
    }

    @objc private func currentUserDidUpdateInfo(_ notification: Notification) {
        if let currentUser = notification.userInfo?["currentUser"] as? User {
            viewModel.currentUser = currentUser
        }
    }

    private func setupPagingVC() {
        var settings = PagingMenuSettings()
        settings.itemSize = .fill(height: menuItemHeight)
        settings.selectedColor = .black
        pagingVC = PagingViewController(settings: settings)

        pagingVC.dataSource = self
        pagingVC.delegate = self
        addChildController(pagingVC)
        pagingVC.view.pinToView(self.view)
    }
}

// MARK: - PagingViewControllerDataSource

extension ProfileBottomController: PagingViewControllerDataSource {

    func numberOfPageControllers(in pagingViewController: PagingViewController) -> Int {
        return viewControllers.count
    }

    func pagingViewController(_ pagingViewController: PagingViewController, pageControllerAt index: Int) -> UIViewController {
        return viewControllers[index]
    }

    func menuItems(in pagingViewController: PagingViewController) -> [DefaultMenuItem] {
        return menuItems
    }
}

// MARK: - PagingViewControllerDelegate

extension ProfileBottomController: PagingViewControllerDelegate {
    func pagingViewController(_ pagingViewController: PagingViewController,
                              didTrasitioningAt currentIndex: Int, progress: CGFloat, indexJustChanged: Bool) {
        if indexJustChanged {
            self.currentIndex = currentIndex
            delegate?.bottomControllerProvider(self, currentViewController: currentViewController, currentIndex: currentIndex)
        }
    }

    func pagingViewController(_ pagingViewController: PagingViewController, didSelectMenuItemAtIndex currentIndex: Int) {
        self.currentIndex = currentIndex
        delegate?.bottomControllerProvider(self, currentViewController: currentViewController, currentIndex: currentIndex)
    }
}
