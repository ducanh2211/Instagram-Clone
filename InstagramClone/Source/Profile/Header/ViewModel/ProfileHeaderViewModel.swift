//
//  ProfileHeaderViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 05/06/2023.
//

import Foundation

class ProfileHeaderViewModel {

    var user: User 
    let isCurrentUser: Bool
    var numberOfPosts: Int = 0
    var numberOfFollowing: Int = 0
    var numberOfFollowers: Int = 0
    var isFollowing: Bool = false
    var getUserStatSuccess: (() -> Void)?
    var getFollowingStateSuccess: (() -> Void)?

    init(user: User, isCurrentUser: Bool) {
        self.user = user
        self.isCurrentUser = isCurrentUser
    }

    func followUser() {
        isFollowing.toggle()
        UserManager.shared.followUser(otherUid: user.uid) { [weak self] _ in
            DispatchQueue.main.async {
                self?.getUserStat()
                self?.getFollowState()
            }
        }
    }

    func unfollowUser() {
        isFollowing.toggle()
        UserManager.shared.unfollowUser(otherUid: user.uid) { [weak self] _ in
            DispatchQueue.main.async {
                self?.getUserStat()
                self?.getFollowState()
            }
        }
    }

    func getFollowState() {
        UserManager.shared.checkFollowState(withOtherUser: user.uid) { [weak self] isFollowing in
            DispatchQueue.main.async {
                self?.isFollowing = isFollowing
                self?.getFollowingStateSuccess?()
            }
        }
    }

    func getUserStat() {
        let dispatchGroup = DispatchGroup()
        getNumberOfPosts(dispatchGroup: dispatchGroup)
        getNumberOfFollowers(dispatchGroup: dispatchGroup)
        getNumberOfFollowing(dispatchGroup: dispatchGroup)
        dispatchGroup.notify(queue: .main) {
            self.getUserStatSuccess?()
        }
    }

    private func getNumberOfPosts(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        UserManager.shared.numberOfPost(forUser: user.uid) { [weak self] count in
            self?.numberOfPosts = count
            dispatchGroup.leave()
        }
    }

    private func getNumberOfFollowing(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        UserManager.shared.numberOfFollowing(forUser: user.uid) { [weak self] count in
            self?.numberOfFollowing = count
            dispatchGroup.leave()
        }
    }

    private func getNumberOfFollowers(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        UserManager.shared.numberOfFollowers(forUser: user.uid) { [weak self] count in
            self?.numberOfFollowers = count
            dispatchGroup.leave()
        }
    }
}
