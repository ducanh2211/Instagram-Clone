//
//  ProfilePhotoDisplayController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

class ProfilePhotoDisplayController: UICollectionViewController {

    var footerView: LoadingIndicatorFooterView!
    let compositionalLayoutConfig = UICollectionViewCompositionalLayoutConfiguration()
    var footerItem: NSCollectionLayoutBoundarySupplementaryItem!

    // MARK: - Properties

    var currentUser: User {
        didSet {
            if rootViewHasLoaded {
                reloadData()
            }
        }
    }
    private let viewModel: ProfilePhotoDisplayViewModel
    private var posts: [Post] = []
    private var rootViewHasLoaded: Bool = false

    // MARK: - Initializer
    
    init(currentUser: User, otherUser: User?) {
        self.currentUser = currentUser
        if let otherUser = otherUser {
            viewModel = ProfilePhotoDisplayViewModel(uid: otherUser.uid)
        } else {
            viewModel = ProfilePhotoDisplayViewModel(uid: currentUser.uid)
        }
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadUserProfileFeed, object: nil)
        print("DEBUG: ProfilePhotoDisplayController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootViewHasLoaded = true
        setupCollecionView()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadUserProfileFeed, object: nil)
    }

    // MARK: - Functions

    @objc private func reloadData() {
        viewModel.reloadData()
        shouldShowFooterView(true)
    }

    private func bindViewModel() {
        viewModel.updatePostsData = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let sortedPosts = self.viewModel.posts.sorted { $0.creationDate > $1.creationDate }
                self.posts = sortedPosts
                self.collectionView.reloadData()
            }
        }
        viewModel.getPosts()
    }

    private func shouldShowFooterView(_ show: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.compositionalLayoutConfig.boundarySupplementaryItems = show ? [self.footerItem] : []
            (self.collectionView.collectionViewLayout as? UICollectionViewCompositionalLayout)?.configuration = self.compositionalLayoutConfig
        }
    }
}

// MARK: - UICollectionViewDataSource, Delegate

extension ProfilePhotoDisplayController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.item]
        cell.configure(with: post.imageUrl)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let vc = PostDetailController(post: post, currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: LoadingIndicatorFooterView.identifier,
            for: indexPath) as! LoadingIndicatorFooterView
        footerView = footer
        footerView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if footer.activityIndicator.isAnimating {
                footer.stopAnimating()
            }
        }
        return footer
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 didEndDisplayingSupplementaryView view: UICollectionReusableView,
                                 forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            footerView.stopAnimating()
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.bounds.height
        if maximumOffset - currentOffset <= 0 {
            if !viewModel.isFechingMore {
                viewModel.getMorePosts()
                if viewModel.hasReachedTheEnd {
                    shouldShowFooterView(false)
                }
            }
        }
    }
}

// MARK: - Setup

extension ProfilePhotoDisplayController {
    private func setupCollecionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: false)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.register(LoadingIndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingIndicatorFooterView.identifier)
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0.5, bottom: 0, trailing: 0.5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1

        let footerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80))

        footerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerItemSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        compositionalLayoutConfig.boundarySupplementaryItems = [footerItem]
        return UICollectionViewCompositionalLayout(section: section, configuration: compositionalLayoutConfig)
    }
}
