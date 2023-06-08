//
//  PostDetailCellViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 07/06/2023.
//

import Foundation

class PostDetailCellViewModel {

    var post: Post
    var commentsCount: Int
    var likesCount: Int
    var likedByCurrentUser: Bool
    var getNumberOfLikesSuccess: (() -> Void)?
    var getNumberOfCommentsSuccess: (() -> Void)?
    var checkLikesStateSuccess: (() -> Void)?

    init(post: Post) {
        self.post = post
        self.likedByCurrentUser = post.likedByCurrentUser
        self.commentsCount = post.commentsCount
        self.likesCount = post.likesCount
    }

    var userAvatarUrl: String {
        return post.user.avatarUrl
    }

    var userName: String {
        return post.user.userName
    }

    var postImageUrl: String {
        return post.imageUrl
    }

    var postImageAspectRatio: CGFloat {
        return post.aspectRatio
    }

    var postCaption: String {
        return post.caption
    }

    var timeLineText: String {
        return timeLineFormatter()
    }

    var captionAttributedText: NSAttributedString {
        let attributedText = NSMutableAttributedString()
            .appendAttributedString(userName, font: .systemFont(ofSize: 14, weight: .bold))
            .appendAttributedString(" \(postCaption)", font: .systemFont(ofSize: 14))
        return attributedText
    }

    var likeCounterText: String {
        if likesCount == 0 {
            return ""
        } else if likesCount == 1 {
            return "1 like"
        } else {
            return "\(likesCount) likes"
        }
    }

    var shouldHideCounterLabel: Bool {
        if likesCount == 0 {
            return true
        } else {
            return false
        }
    }

    var commentsCounterText: String {
        if commentsCount == 0 {
            return "Add a comment..."
        } else if commentsCount == 1 {
            return "View 1 comment"
        } else {
            return "View all \(commentsCount) comments"
        }
    }

    func getNumberOfComments() {
        PostManager.shared.numberOfComments(forPost: post.postId) { [weak self] count in
            DispatchQueue.main.async {
                self?.commentsCount = count
                self?.getNumberOfCommentsSuccess?()
            }
        }
    }

    func getNumberOfLikes() {
        PostManager.shared.numberOfLikes(forPost: post.postId) { [weak self] count in
            DispatchQueue.main.async {
                self?.likesCount = count
                self?.getNumberOfLikesSuccess?()
            }
        }
    }

    func checkLikesState() {
        PostManager.shared.checkIfUserLikePost(postId: post.postId) { [weak self] likedByCurrentUser in
            DispatchQueue.main.async {
                self?.likedByCurrentUser = likedByCurrentUser
                self?.checkLikesStateSuccess?()
            }
        }
    }

    func likePost() {
        PostManager.shared.likePost(post.postId) { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkLikesState()
                self?.getNumberOfLikes()
            }
        }
    }

    func unlikePost() {
        PostManager.shared.unlikePost(post.postId) { [weak self] _ in
            DispatchQueue.main.async {
                self?.checkLikesState()
                self?.getNumberOfLikes()
            }
        }
    }

    private func timeLineFormatter() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.weekOfMonth, .day, .hour, .minute, .second]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        let duration = formatter.string(from: post.creationDate, to: Date()) ?? ""
        return "\(duration) ago"
    }

}
