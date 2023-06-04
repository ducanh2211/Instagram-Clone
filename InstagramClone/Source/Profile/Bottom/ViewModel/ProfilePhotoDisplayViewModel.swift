//
//  ProfilePhotoDisplayViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 31/05/2023.
//

import Foundation
import FirebaseFirestore

class ProfilePhotoDisplayViewModel {

    var posts = [Post]()
    var updatePostsData: (() -> Void)?
    var isFechingMore: Bool = false
    var hasReachedTheEnd: Bool = false
    private var uid: String
    private var query: Query!
    private var lastDocument: DocumentSnapshot?
    private let pageSize = 15

    init(uid: String) {
        self.uid = uid
        createQuery()
    }

    private func createQuery() {
        query = Firestore.firestore()
            .collection(Firebase.RootCollection.userPosts)
            .document(uid)
            .collection("posts")
            .order(by: Firebase.Post.creationDate, descending: true)
            .limit(to: pageSize)
    }

    func getPosts() {
        let dispatchGroup = DispatchGroup()

        query.getDocuments { [weak self] querySnapshot, error in
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
                let postId = document.documentID

                dispatchGroup.enter()
                PostManager.shared.fetchPost(postId) { post in
                    if let post = post {
                        self.posts.append(post)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.isFechingMore = false
                self.updatePostsData?()
            }
        }
    }

    func getMorePosts() {
        guard let lastDocument = lastDocument else { return }
        isFechingMore = true
        query = query.start(afterDocument: lastDocument)
        getPosts()
    }

    func reloadData() {
        posts.removeAll()
        isFechingMore = false
        hasReachedTheEnd = false
        lastDocument = nil
        createQuery()
        getPosts()
    }
}
