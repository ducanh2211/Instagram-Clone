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

//    var user: User
//    var posts: [Post] = []
    let navBarHeight: CGFloat = 44
    private var lastContentOffset: CGFloat = -44
    private var isFirstLoading: Bool = true
    private let viewModel = HomeViewModel()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupView()
        bindViewModel()
//        fetchPosts()
    }

//    init(user: User) {
//        self.user = user
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

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
//        fetchPosts()
        viewModel.reloadData()
    }

//    func fetchPosts() {
//        if isFirstLoading {
//            ProgressHUD.show()
//        }
//        PostManager.shared.fetchHomePosts(forCurrentUser: user.uid) { [weak self] posts in
//            DispatchQueue.main.async {
//                self?.posts = posts.shuffled()
//                self?.isFirstLoading = false
//                self?.refreshControl.endRefreshing()
//                self?.collectionView.reloadData()
//                ProgressHUD.remove()
//            }
//        }
//    }
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
        guard let post = cell.post, let currentUser = viewModel.currentUser else { return }
        let vc = ProfileController(currentUser: currentUser, otherUser: post.user)
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
        guard let post = cell.post, let currentUser = viewModel.currentUser else { return }
        let vc = CommentController(post: post, currentUser: currentUser)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapLikeCounterLabel(_ cell: HomePostCell) {
        guard let post = cell.post else { return }
        let vc = LikeDetailController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapLikeButton(_ cell: HomePostCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
//        var post = posts[indexPath.item]
        var post = viewModel.posts[indexPath.item]
        
        if post.likedByCurrentUser {
            PostManager.shared.unlikePost(post.postId) { [weak self] error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let error = error {
                        print("DEBUG: unlike post error: \(error)")
                        return
                    }
                    post.likedByCurrentUser = false
                    post.likesCount -= 1
//                    self.posts[indexPath.item] = post
                    self.viewModel.posts[indexPath.item] = post
                    self.collectionView.performBatchUpdates {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        } else {
            PostManager.shared.likePost(post.postId) { [weak self] error in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    if let error = error {
                        print("DEBUG: unlike post error: \(error)")
                        return
                    }
                    post.likedByCurrentUser = true
                    post.likesCount += 1
//                    self.posts[indexPath.item] = post
                    self.viewModel.posts[indexPath.item] = post
                    self.collectionView.performBatchUpdates {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        HomeSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if HomeSection(rawValue: section) == .story { return 10 }
//        return posts.count
        return viewModel.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if HomeSection(rawValue: indexPath.section) == .story {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeStoryCell.identifier, for: indexPath) as! HomeStoryCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomePostCell.identifier, for: indexPath) as! HomePostCell
            cell.delegate = self
//            cell.post = posts[indexPath.item]
            cell.post = viewModel.posts[indexPath.item]
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
