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

    var currentUser: User
    var posts = [Post]()
    var isFirstLoading: Bool = true
    var isLoading: Bool = false {
        didSet { handleLoadingIndicator?() }
    }
    var updatePostsData: (() -> Void)?
    var handleLoadingIndicator: (() -> Void)?
    private let userFollowingRef = Firestore.firestore().collection(Firebase.RootCollection.userFollowing)

    var storyPhotos: [String] = [
        "story-photo-1", "story-photo-2", "story-photo-3",
        "story-photo-4", "story-photo-5", "story-photo-6",
        "story-photo-7", "story-photo-8", "story-photo-9"
    ]

    init(currentUser: User) {
        self.currentUser = currentUser
    }

    deinit {
        print("DEBUG: HomeViewModel deinit")
    }

    func getPosts() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        isLoading = true

        UserManager.shared.fetchFollowingUid(forUser: currentUid) { [weak self] followingUid in
            guard let self = self else { return }
            if followingUid.isEmpty {
                self.isLoading = false
                return
            }
            self.fetchPostsForFollowUser(followingUid: followingUid)
        }
    }

    func reloadData() {
        getPosts()
    }

    private func fetchPostsForFollowUser(followingUid: [String]) {
        var postsData = [Post]()
        var numberOfUsers: Int = 0

        followingUid.forEach { uid in
            PostManager.shared.fetchPosts(forUser: uid) { [weak self] posts in
                guard let self = self else { return }
                numberOfUsers += 1
                postsData.append(contentsOf: posts)

                if numberOfUsers == followingUid.count {
                    self.posts = postsData.shuffled()
                    self.isLoading = false
                    self.isFirstLoading = false
                    self.updatePostsData?()
                }
            }
        }
    }
}
