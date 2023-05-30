//
//  CommentController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 28/05/2023.
//

import UIKit

class CommentController: UIViewController, CustomizableNavigationBar {

    // MARK: - Properties

    var navBar: CustomNavigationBar!
    var activityIndicator: UIActivityIndicatorView!
    var collectionView: UICollectionView!

    lazy var commentSection: CommentInputAccessoryView = {
        let view = CommentInputAccessoryView()
        view.delegate = self
        view.profileImageString = currentUser.avatarUrl
        
        return view
    }()
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var inputAccessoryView: UIView? {
        return commentSection
    }
    
    // MARK: - Initializer

    var post: Post
    var currentUser: User
    var comments: [Comment] = [] {
        didSet { collectionView.reloadData() }
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
        fetchComments()
    }

    // MARK: - Functions

    private func fetchComments() {
        activityIndicator.startAnimating()
        PostManager.shared.fetchComments(forPost: post.postId) { comments in
            DispatchQueue.main.async {
                let sortedComments = comments.sorted { $0.creationDate > $1.creationDate }
                self.comments = sortedComments
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - CommentInputAccessoryDelegate

extension CommentController: CommentInputAccessoryDelegate {
    func didTapSendButton(with text: String) {
        PostManager.shared.sendComment(toPost: post.postId, content: text) { error in
            DispatchQueue.main.async {
                guard error == nil else { return }
                let fakeComment = Comment(commentId: "", content: text, creationDate: Date(), user: self.currentUser)
                self.comments.insert(fakeComment, at: 0)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        let comment = comments[indexPath.item]
        cell.comment = comment
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: CommentHeader.identifier, for: indexPath) as! CommentHeader
            header.post = post
            return header
        }
        return UICollectionReusableView()
    }
}
