//
//  ProfilePhotoDisplayController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

class ProfilePhotoDisplayController: UICollectionViewController {

    var otherUser: User?
    var currentUser: User {
        didSet { fetchPosts() }
    }
    private var posts: [Post] = [] {
        didSet { collectionView.reloadData() }
    }

    init(currentUser: User, otherUser: User?) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEBUG: ProfilePhotoDisplayController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollecionView()
        fetchPosts()
    }
    
    private func fetchPosts() {
        let user = otherUser == nil ? currentUser : otherUser!

        PostManager.shared.fetchPosts(forUser: user.uid) { posts in
            DispatchQueue.main.async {
                let sorted = posts.sorted { $0.creationDate > $1.creationDate }
                self.posts = sorted
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfilePhotoDisplayController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.item]
        cell.configure(with: post.imageUrl)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.item]
        let vc = PostDetailController(post: post, currentUser: currentUser)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Setup

extension ProfilePhotoDisplayController {
    private func setupCollecionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: false)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
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
        return UICollectionViewCompositionalLayout(section: section)
    }
}
