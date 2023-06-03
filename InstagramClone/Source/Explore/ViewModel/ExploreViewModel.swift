//
//  ExploreViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 31/05/2023.
//

import Foundation
import FirebaseFirestore

class ExploreViewModel {

    var posts = [Post]()
    var updatePostsData: (() -> Void)?
    var isFechingMore: Bool = false
    var hasReachedTheEnd: Bool = false
    private var currentUid: String
    private var query: Query!
    private var lastDocument: DocumentSnapshot?
    private var pageSize: Int = 18

    init(currentUid: String) {
        self.currentUid = currentUid
        createQuery()
    }

    private func createQuery() {
        query = Firestore.firestore()
            .collection(Firebase.RootCollection.posts)
            .whereField(Firebase.Post.uid, isNotEqualTo: currentUid)
            .order(by: Firebase.Post.uid)
    }

    func getPosts() {
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
                self.isFechingMore = false
                self.posts.append(contentsOf: postsData.shuffled())
                self.updatePostsData?()
            }
        }
    }

    func getMorePosts() {
        guard let lastDocument = lastDocument else { return }
        isFechingMore = true
        pageSize = 12
        query = query.start(afterDocument: lastDocument)
        getPosts()
    }

    func removeData() {
        posts.removeAll()
        lastDocument = nil
        isFechingMore = false
        hasReachedTheEnd = false
        pageSize = 18
        createQuery()
    }
}
