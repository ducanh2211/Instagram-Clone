//
//  ExploreController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class ExploreController: UIViewController, UserSearchViewDelegate {

    // MARK: - Properties

    private var searchView: UserSearchView!
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private var searchViewHeightConstraint: NSLayoutConstraint!
    private let searchViewHeight: CGFloat = 56
    private var currentUser: User
    private var posts: [Post] = [] {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Life cycle

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchPosts()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.searchBar.resignFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if searchView.isPresenting {
            searchView.searchBar.becomeFirstResponder()
        }
    }

    // MARK: - Functions

    func fetchPosts() {
        PostManager.shared.fetchExplorePosts { posts in
            DispatchQueue.main.async {
                let sortedPosts = posts.sorted { $0.creationDate > $1.creationDate }
                self.posts = sortedPosts
            }
        }
    }

    func didSelectUser(_ user: User) {
        let otherUser = currentUser.uid == user.uid ? nil : user
        let vc = ProfileController(currentUser: currentUser, otherUser: otherUser)
        navigationController?.pushViewController(vc, animated: true)
    }

    func showSearchView() {
        searchViewHeightConstraint.constant = view.frame.height - view.safeAreaInsets.top
    }

    func hideSearchView() {
        searchViewHeightConstraint.constant = searchViewHeight
    }
}

// MARK: - UICollectionViewDataSource

extension ExploreController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.item]
        cell.configure(with: post.imageUrl)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let vc = PostDetailController(post: post, currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup

extension ExploreController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        setupSearchView()
        setupCollectionView()
        setupConstraints()
    }

    private func setupSearchView() {
        searchView = UserSearchView()
        searchView.delegate = self
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }

    private func setupConstraints() {
        searchView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        view.addSubview(searchView)

        searchViewHeightConstraint = searchView.heightAnchor.constraint(equalToConstant: searchViewHeight)

        NSLayoutConstraint.activate([
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchViewHeightConstraint,

            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: searchView.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalWidth(1/3)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0.5, bottom: 0, trailing: 0.5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1)
            , heightDimension: .fractionalWidth(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: searchViewHeight, leading: 0, bottom: 0, trailing: 0)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
