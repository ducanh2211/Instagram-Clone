//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

extension HomeController {
    enum HomeSection: Int, CaseIterable {
        case story
        case post
    }
}

class HomeController: UIViewController, CustomizableNavigationBar {

    // MARK: - UI components

    var fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    var navBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()

    // MARK: - Properties

    let navBarHeight: CGFloat = 44
    private var lastContentOffset: CGFloat = -44
    private var isFirstLoading: Bool = true
    private let viewModel: HomeViewModel

    // MARK: - Life cycle

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEBUG: HomeController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        bindViewModel()
    }

    // MARK: - Functions

    func bindViewModel() {
        viewModel.handleLoadingIndicator = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.viewModel.isFirstLoading && self.viewModel.isLoading {
                    ProgressHUD.show()
                } else {
                    ProgressHUD.remove()
                }
            }
        }
        viewModel.updatePostsData = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        viewModel.getPosts()
    }

    @objc func handleRefresh() {
        viewModel.reloadData()
    }
}

// MARK: - HomePostCellDelegate

extension HomeController: HomePostCellDelegate {
    func didTapProfileImageView(_ cell: HomePostCell) {
        pushToProfileController(cell)
    }

    func didTapUserNameLabel(_ cell: HomePostCell) {
        pushToProfileController(cell)
    }

    private func pushToProfileController(_ cell: HomePostCell) {
        guard let post = cell.viewModel?.post else { return }
        let otherUser = viewModel.currentUser.uid == post.user.uid ? nil : post.user
        let profileViewModel = ProfileViewModel(type: .other(currentUser: viewModel.currentUser, otherUser: otherUser))
        let vc = ProfileController(viewModel: profileViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapCommentButton(_ cell: HomePostCell) {
        pushToCommentController(cell)
    }

    func didTapCommentCounterLabel(_ cell: HomePostCell) {
        pushToCommentController(cell)
    }

    func didTapCaptionLabel(_ cell: HomePostCell) {
        pushToCommentController(cell)
    }

    private func pushToCommentController(_ cell: HomePostCell) {
        guard let post = cell.viewModel?.post else { return }
        let vc = CommentController(post: post, currentUser: viewModel.currentUser)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapLikeCounterLabel(_ cell: HomePostCell) {
        guard let post = cell.viewModel?.post else { return }
        let vc = LikeDetailController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapLikeButton(_ cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        guard let post = cell.viewModel?.post else { return }
        self.viewModel.posts[indexPath.item] = post
        collectionView.performBatchUpdates { }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if HomeSection(rawValue: section) == .story { return 10 }
        return viewModel.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if HomeSection(rawValue: indexPath.section) == .story {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStoryCell.identifier, for: indexPath) as! HomeStoryCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.identifier, for: indexPath) as! HomePostCell
            cell.delegate = self
            let post = viewModel.posts[indexPath.item]
            let cellViewModel = HomePostCellViewModel(post: post)
            cell.viewModel = cellViewModel
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == collectionView else { return }
        let currentOffset = scrollView.contentOffset.y

        if currentOffset < -navBarHeight {
            lastContentOffset = -navBarHeight
            return
        }
        if currentOffset > scrollView.contentSize.height {
            lastContentOffset = scrollView.contentSize.height
            return
        }

        if currentOffset > lastContentOffset {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.navBar.transform = CGAffineTransform(translationX: 0, y: -self.navBarHeight)
            }
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.navBar.transform = .identity
            }
        }
        lastContentOffset = currentOffset
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y

        if currentOffset == -navBarHeight {
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
                self.navBar.transform = .identity
            }
        }
        lastContentOffset = currentOffset
    }
}
