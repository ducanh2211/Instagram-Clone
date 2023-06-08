//
//  CommentViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 02/06/2023.
//

import Foundation
import FirebaseFirestore

class CommentViewModel {

    var comments = [Comment]()
    var updateCommentsData: (() -> Void)?
    var isFetchingMore: Bool = false
    private let postId: String
    private let currentUser: User
    private var pageSize: Int = 15
    private var query: Query!
    private var lastDocument: DocumentSnapshot?

    init(postId: String, currentUser: User) {
        self.postId = postId
        self.currentUser = currentUser
        createQuery()
    }

    func getComments() {
        query.getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let documents = querySnapshot?.documents, error == nil else {
                return
            }

            if documents.count < self.pageSize {
                self.lastDocument = nil
            } else {
                self.lastDocument = documents.last
            }
            self.fetchComments(documents: documents)
        }
    }

    func getMoreComments() {
        guard let lastDocument = lastDocument else { return }
        isFetchingMore = true
        query = query.start(afterDocument: lastDocument)
        getComments()
    }

    func updloadComment(content: String) {
        CommentManager.shared.sendComment(toPost: postId, content: content, user: currentUser) { [weak self] comment in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let comment = comment {
                    self.comments.insert(comment, at: 0)
                    self.updateCommentsData?()
                }
            }
        }
    }

    private func createQuery() {
        query = Firestore.firestore()
            .collection(Firebase.RootCollection.postComments)
            .document(postId)
            .collection(Firebase.Post.comments)
            .order(by: Firebase.Post.creationDate, descending: true)
            .limit(to: pageSize)
    }

    private func fetchComments(documents: [QueryDocumentSnapshot]) {
        let dispatchGroup = DispatchGroup()

        documents.forEach { document in
            let commentId = document.documentID

            dispatchGroup.enter()
            CommentManager.shared.fetchComment(commentId) { comment in
                if let comment = comment {
                    self.comments.append(comment)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.comments = self.comments.sorted { $0.creationDate > $1.creationDate }
            self.isFetchingMore = false
            self.updateCommentsData?()
        }
    }
}
