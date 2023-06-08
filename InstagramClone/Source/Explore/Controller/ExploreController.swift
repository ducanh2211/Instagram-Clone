//
//  ExploreController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class ExploreController: UIViewController {

    // MARK: - UI components

    var searchView: UserSearchView!
    var collectionView: UICollectionView!
    var footerView: LoadingIndicatorFooterView!
    let refreshControl = UIRefreshControl()
    var searchViewHeightConstraint: NSLayoutConstraint!
    let compositionalLayoutConfig = UICollectionViewCompositionalLayoutConfiguration()
    var footerItem: NSCollectionLayoutBoundarySupplementaryItem!

    // MARK: - Properties

    let searchViewHeight: CGFloat = 56
    private let viewModel: ExploreViewModel

    // MARK: - Life cycle

    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEBUG: ExploreController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchView.isPresenting {
            searchView.searchBar.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.searchBar.resignFirstResponder()
    }

    // MARK: - Functions

    private func bindViewModel() {
        viewModel.updatePostsData = { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
        viewModel.getPosts()
    }

    @objc func handleRefresh() {
        viewModel.reloadData()
        shouldShowFooterView(true)
    }

    private func shouldShowFooterView(_ show: Bool) {
        compositionalLayoutConfig.boundarySupplementaryItems = show ? [footerItem] : []
        (collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout)?.configuration = compositionalLayoutConfig
    }
}

// MARK: - UserSearchViewDelegate

extension ExploreController: UserSearchViewDelegate {
    func didSelectUser(_ user: User) {
        let currentUser = viewModel.currentUser
        let otherUser = currentUser.uid == user.uid ? nil : user
        let profileViewModel = ProfileViewModel(type: .other(currentUser: currentUser, otherUser: otherUser))
        let vc = ProfileController(viewModel: profileViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    func showSearchView() {
        searchViewHeightConstraint.constant = view.frame.height - view.safeAreaInsets.top
    }

    func hideSearchView() {
        searchViewHeightConstraint.constant = searchViewHeight
    }
}

// MARK: - UICollectionViewDataSource, Delegate

extension ExploreController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let post = viewModel.posts[indexPath.item]
        cell.configure(with: post.imageUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = viewModel.posts[indexPath.item]
        let vc = PostDetailController(post: post, currentUser: viewModel.currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: LoadingIndicatorFooterView.identifier, for: indexPath) as! LoadingIndicatorFooterView
            footerView = footer
            footerView.startAnimating()
            return footer
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplayingSupplementaryView view: UICollectionReusableView,
                        forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            footerView.stopAnimating()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height

        if maximumOffset - currentOffset <= 20 {
            if !viewModel.isFechingMore {
                viewModel.getMorePosts()
            }
            if viewModel.hasReachedTheEnd {
                shouldShowFooterView(false)
            }
        }
    }
}
