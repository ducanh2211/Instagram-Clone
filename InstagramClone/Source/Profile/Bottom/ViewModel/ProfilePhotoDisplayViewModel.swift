//
//  ProfilePhotoDisplayViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 31/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ProfilePhotoDisplayViewModel {

    var currentUser: User
    var otherUser: User?
    var posts = [Post]()
    var updatePostsData: (() -> Void)?
    var isFechingMore: Bool = false
    var hasReachedTheEnd: Bool = false
    private var query: Query?
    private var lastDocument: DocumentSnapshot?
    private let pageSize = 15
    private var pageId: Int = 0

    init(currentUser: User, otherUser: User?) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        createQuery()
    }

    private func createQuery() {
        let uid = otherUser?.uid ?? currentUser.uid

        query = Firestore.firestore()
            .collection(Firebase.RootCollection.userPosts)
            .document(uid)
            .collection("posts")
            .order(by: Firebase.Post.creationDate, descending: true)
            .limit(to: pageSize)
    }

    func getPosts() {
        guard let query = query else { return }
        pageId += 1

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
            self.fetchPosts(documents: documents)
        }
    }

    func getMorePosts() {
        guard let lastDocument = lastDocument else { return }
        isFechingMore = true
        query = query?.start(afterDocument: lastDocument)
        getPosts()
    }

    func reloadData() {
        pageId = 0
        isFechingMore = false
        hasReachedTheEnd = false
        lastDocument = nil
        createQuery()
        getPosts()
    }

    private func fetchPosts(documents: [QueryDocumentSnapshot]) {
        var postsData = [Post]()
        let dispatchGroup = DispatchGroup()

        documents.forEach { document in
            let postId = document.documentID

            dispatchGroup.enter()
            PostManager.shared.fetchPost(postId) { post in
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
            self.posts.append(contentsOf: postsData)
            self.posts = self.posts.sorted { $0.creationDate > $1.creationDate }
            self.updatePostsData?()
        }
    }
}
