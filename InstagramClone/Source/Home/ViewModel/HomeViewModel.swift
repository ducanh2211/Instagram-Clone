//
//  HomeViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/06/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel {

    var currentUser: User?
    var posts = [Post]()
    var isFirstLoading: Bool = true
    var isLoading: Bool = false {
        didSet { handleLoadingIndicator?() }
    }
    var updatePostsData: (() -> Void)?
    var handleLoadingIndicator: (() -> Void)?
    private let userFollowingRef = Firestore.firestore().collection(Firebase.RootCollection.userFollowing)

    init() {
        fetchCurrentUser()
    }

    private func fetchCurrentUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        UserManager.shared.fetchUser(withUid: currentUid) { [weak self] user, error in
            if let user = user {
                self?.currentUser = user
            }
        }
    }

    func getPosts() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        var postsData = [Post]()
        var numberOfUsers: Int = 0
        isLoading = true

        UserManager.shared.fetchFollowingUid(forUser: currentUid) { [weak self] followingUid in
            guard let self = self else { return }
            if followingUid.isEmpty {
                self.isLoading = false
                return
            }

            followingUid.forEach { uid in
                PostManager.shared.fetchPosts(forUser: uid) { posts in
                    numberOfUsers += 1
                    postsData.append(contentsOf: posts)

                    if numberOfUsers == followingUid.count {
                        self.posts.removeAll()
                        self.posts = postsData.shuffled()
                        self.isLoading = false
                        self.isFirstLoading = false
                        self.updatePostsData?()
                    }
                }
            }
        }
    }

    func reloadData() {
        getPosts()
    }
}
