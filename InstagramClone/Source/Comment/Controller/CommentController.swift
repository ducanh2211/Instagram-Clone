//
//  CommentController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 02/06/2023.
//

import UIKit

class CommentController: UIViewController {

    // MARK: - UI components

    var navBar: CustomNavigationBar!
    var collectionView: UICollectionView!
    var footerView: LoadingIndicatorFooterView!
    var inputSection: CommentInputView!
    var inputSectionBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties

    var post: Post
    var currentUser: User
    let viewModel: CommentViewModel

    // MARK: - Initializer

    init(post: Post, currentUser: User) {
        self.post = post
        self.currentUser = currentUser
        self.viewModel = CommentViewModel(postId: post.postId, currentUser: currentUser)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeNotification()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        addNotification()
    }

    // MARK: - Functions

    func bindViewModel() {
        viewModel.getComments()
        viewModel.updateCommentsData = { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardSize: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let bottomSafeArea: CGFloat = view.safeAreaInsets.bottom

        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        let shouldScroll = !visibleIndexPaths.isEmpty
        var maxVisibleIndexPath = IndexPath(item: 0, section: 0)
        visibleIndexPaths.forEach { indexPath in
            if indexPath.item > maxVisibleIndexPath.item {
                maxVisibleIndexPath = indexPath
            }
        }

        let distance = keyboardSize.height - bottomSafeArea
        inputSectionBottomConstraint.constant = -distance
        collectionView.contentInset.bottom = distance

        UIView.animate(withDuration: duration, delay: 0) {
            if shouldScroll {
                self.collectionView.scrollToItem(at: maxVisibleIndexPath, at: .bottom, animated: false)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

        inputSectionBottomConstraint.constant = 0
        collectionView.contentInset.bottom = 0
        UIView.animate(withDuration: duration, delay: 0) {
            self.view.layoutIfNeeded()
        }
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - CommentInputViewDelegate

extension CommentController: CommentInputViewDelegate {
    func didTapSendButton(with text: String) {
        viewModel.updloadComment(content: text)
    }
}

// MARK: - UICollectionViewDataSource

extension CommentController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.comments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        let comment = viewModel.comments[indexPath.item]
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
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: LoadingIndicatorFooterView.identifier, for: indexPath) as! LoadingIndicatorFooterView
            footerView = footer
            footerView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if footer.activityIndicator.isAnimating {
                    footer.stopAnimating()
                }
            }
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
        if maximumOffset - currentOffset <= 10 {
            if !viewModel.isFetchingMore {
                viewModel.getMoreComments()
            }
        }
    }
}

