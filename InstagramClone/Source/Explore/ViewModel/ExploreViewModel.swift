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

    var currentUser: User
    var posts = [Post]()
    var updatePostsData: (() -> Void)?
    var isFechingMore: Bool = false
    var hasReachedTheEnd: Bool = false
    private var query: Query?
    private var lastDocument: DocumentSnapshot?
    private var pageSize: Int = 18
    private var pageId: Int = 0

    init(currentUser: User) {
        self.currentUser = currentUser
        createQuery()
    }

    deinit {
        print("DEBUG: ExploreViewModel deinit")
    }

    // MARK: - Private

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
        pageId += 1

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
            self.fetchPosts(documents: documents)
        }
    }

    func getMorePosts() {
        guard let lastDocument = lastDocument else { return }
        isFechingMore = true
        pageSize = 12
        query = query?.start(afterDocument: lastDocument)
        getPosts()
    }

    func reloadData() {
        pageId = 0
        lastDocument = nil
        isFechingMore = false
        hasReachedTheEnd = false
        pageSize = 18
        createQuery()
        getPosts()
    }

    private func fetchPosts(documents: [QueryDocumentSnapshot]) {
        var postsData = [Post]()
        let dispatchGroup = DispatchGroup()

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
