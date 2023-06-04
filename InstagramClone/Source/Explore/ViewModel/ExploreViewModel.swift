//
//  ExploreViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 31/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ExploreViewModel {

    var currentUser: User?
    var posts = [Post]()
    var updatePostsData: (() -> Void)?
    var isFechingMore: Bool = false
    var hasReachedTheEnd: Bool = false
    private var query: Query?
    private var lastDocument: DocumentSnapshot?
    private var pageSize: Int = 18
    private var pageId: Int = 1

    init() {
        fetchCurrentUser()
        createQuery()
    }

    // MARK: - Private

    private func fetchCurrentUser() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        UserManager.shared.fetchUser(withUid: currentUid) { [weak self] user, error in
            if let user = user {
                self?.currentUser = user
            }
        }
    }

    private func createQuery() {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            query = nil
            return
        }
        query = Firestore.firestore()
            .collection(Firebase.RootCollection.posts)
            .whereField(Firebase.Post.uid, isNotEqualTo: currentUid)
            .order(by: Firebase.Post.uid)
    }

    // MARK: - Public

    func getPosts() {
        guard let query = query else { return }
        let dispatchGroup = DispatchGroup()
        var postsData = [Post]()

        query.limit(to: pageSize).getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let documents = querySnapshot?.documents, error == nil else {
                return
            }

            if documents.count < self.pageSize {
                self.lastDocument = nil
                self.hasReachedTheEnd = true
            } else {
                self.lastDocument = documents.last
            }

            documents.forEach { document in
                let dictionary = document.data()
                let postId = document.documentID
                guard let uid = dictionary[Firebase.User.uid] as? String else { return }

                dispatchGroup.enter()
                PostManager.shared.fetchDataForPost(postId, uid: uid, dictionary: dictionary) { post in
                    if let post = post {
                        postsData.append(post)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                if self.pageId == 1 {
                    self.posts.removeAll()
                }
                self.isFechingMore = false
                self.posts.append(contentsOf: postsData.shuffled())
                self.updatePostsData?()
            }
        }
    }

    func getMorePosts() {
        guard let lastDocument = lastDocument else { return }
        isFechingMore = true
        pageId += 1
        pageSize = 12
        query = query?.start(afterDocument: lastDocument)
        getPosts()
    }

    func reloadData() {
        pageId = 1
        lastDocument = nil
        isFechingMore = false
        hasReachedTheEnd = false
        pageSize = 18
        createQuery()
        getPosts()
    }
}
