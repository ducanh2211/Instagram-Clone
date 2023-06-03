//
//  PostDetailController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 29/05/2023.
//

import UIKit

class PostDetailController: UIViewController, CustomizableNavigationBar {

    var navBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    var post: Post
    var currentUser: User
    var isLogInUser: Bool {
        return currentUser.uid == post.user.uid
    }

    init(post: Post, currentUser: User) {
        self.post = post
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - PostDetailCellDelegate

extension PostDetailController: PostDetailCellDelegate {
    func didTapProfileImageView(_ cell: PostDetailCell) {
        pushToProfileController()
    }

    func didTapUserNameLabel(_ cell: PostDetailCell) {
        pushToProfileController()
    }

    private func pushToProfileController() {
        let otherUser = isLogInUser ? nil : post.user
        let vc = ProfileController(currentUser: currentUser, otherUser: otherUser)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapCommentButton(_ cell: PostDetailCell) {
        pushToCommentController()
    }

    func didTapCommentCounterLabel(_ cell: PostDetailCell) {
        pushToCommentController()
    }

    func didTapCaptionLabel(_ cell: PostDetailCell) {
        pushToCommentController()
    }

    private func pushToCommentController() {
//        let vc = CommentController(post: post, currentUser: currentUser)
        let vc = CommentController(post: post, currentUser: currentUser)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapLikeCounterLabel(_ cell: PostDetailCell) {
        guard let post = cell.post else { return }
        let vc = LikeDetailController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }

    func didTapLikeButton(_ cell: PostDetailCell) { }
}

// MARK: - UICollectionViewDataSource

extension PostDetailController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostDetailCell.identifier, for: indexPath) as! PostDetailCell
        cell.delegate = self
        cell.post = post
        return cell
    }
}

// MARK: - Setup

extension PostDetailController {
    func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavBar() {
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
        let backButton = AttributedButton(image: image) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        let title = isLogInUser ? "Posts" : "Explore"
        navBar = CustomNavigationBar(title: title, shouldShowSeparator: true, leftBarButtons: [backButton])
    }

    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(PostDetailCell.self, forCellWithReuseIdentifier: PostDetailCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupConstraints() {
        view.addSubview(navBar)
        view.addSubview(collectionView)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(600)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(600)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
}
