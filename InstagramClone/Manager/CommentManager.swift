//
//  CommentManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 03/06/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CommentManager {

    static let shared: CommentManager = CommentManager()
    private let commentsRef = Firestore.firestore().collection(Firebase.RootCollection.comments)
    private let postCommentsRef = Firestore.firestore().collection(Firebase.RootCollection.postComments)

    func sendComment(toPost postId: String, content: String, user: User, completion: @escaping (Comment?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let commentRef = commentsRef.document()
        let commentId = commentRef.documentID

        let creationDate = Date()
        let commentData: [String: Any] = [
            Firebase.Comment.commentId: commentId,
            Firebase.Comment.content: content,
            Firebase.Post.creationDate: creationDate,
            Firebase.Post.uid: currentUid
        ]

        commentRef.setData(commentData) { [weak self] error in
            guard let self = self else { return }
            guard error == nil else {
                completion(nil)
                return
            }

            self.postCommentsRef.document(postId).setData(["dummy": 1])
            self.postCommentsRef.document(postId)
                .collection(Firebase.Post.comments).document(commentId).setData([Firebase.Post.creationDate : creationDate]) { error in
                    guard error == nil else {
                        completion(nil)
                        return
                    }
                    let comment = Comment(user: user, dictionary: commentData)
                    completion(comment)
                }
        }
    }

    func fetchComment(_ commentId: String, completion: @escaping (Comment?) -> Void) {
        commentsRef.document(commentId).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            guard let uid = dictionary[Firebase.Comment.uid] as? String else {
                completion(nil)
                return
            }

            UserManager.shared.fetchUser(withUid: uid) { user, error in
                guard let user = user, error == nil else {
                    completion(nil)
                    return
                }

                let comment = Comment(user: user, dictionary: dictionary)
                completion(comment)
            }
        }
    }
}
