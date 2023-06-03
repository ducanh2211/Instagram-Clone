//
//  PostManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 25/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class PostManager {

    // MARK: - Properties

    static let shared: PostManager = PostManager()
    private let postsRef = Firestore.firestore().collection(Firebase.RootCollection.posts)
    private let postLikesRef = Firestore.firestore().collection(Firebase.RootCollection.postLikes)
    private let postCommentsRef = Firestore.firestore().collection(Firebase.RootCollection.postComments)
    private let userPostsRef = Firestore.firestore().collection(Firebase.RootCollection.userPosts)
    private let userFollowingRef = Firestore.firestore().collection(Firebase.RootCollection.userFollowing)

    deinit {
        print("DEBUG: Post Manager deinit")
    }

    // MARK: - Public funtions

    func createPost(withImage imageData: Data, imageAspectRatio aspectRatio: Double,
                    caption: String, completion: @escaping (Error?) -> Void) {

        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let postRef = postsRef.document()
        let postId = postRef.documentID

        StorageManager.shared.uploadPostImage(imageData, folderName: postId) { [weak self] imageUrl, error in
            guard let self = self else { return }
            guard error == nil else {
                completion(error)
                return
            }

            let creationDate = Date()
            let postData: [String: Any] = [
                Firebase.Post.postId: postId,
                Firebase.Post.caption: caption,
                Firebase.Post.imageUrl: imageUrl!,
                Firebase.Post.aspectRatio: aspectRatio,
                Firebase.Post.creationDate: creationDate,
                Firebase.Post.uid: currentUid
            ]

            postRef.setData(postData) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                self.userPostsRef.document(currentUid).setData(["dummy": 1])

                self.userPostsRef.document(currentUid)
                    .collection("posts").document(postId).setData([Firebase.Post.creationDate : creationDate]) { error in
                        guard error == nil else {
                            completion(error)
                            return
                        }
                        completion(nil)
                }
            }
        }
    }

    func fetchPost(_ postId: String, completion: @escaping (Post?) -> Void) {
        postsRef.document(postId).getDocument { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            guard let uid = dictionary[Firebase.Post.uid] as? String else {
                completion(nil)
                return
            }
            self.fetchDataForPost(postId, uid: uid, dictionary: dictionary) { post in
                completion(post)
            }
        }
    }

    func fetchDataForPost(_ postId: String, uid: String, dictionary: [String: Any], completion: @escaping (Post?) -> Void) {
        UserManager.shared.fetchUser(withUid: uid) { [weak self] user, error in
            guard let self = self else { return }
            guard let user = user, error == nil else {
                completion(nil)
                return
            }
            var post = Post(user: user, dictionary: dictionary)

            self.checkLikeStateForPost(postId) { likesCount, likedByCurrentUser in
                self.numberOfComments(forPost: postId) { commentsCount in
                    post.likedByCurrentUser = likedByCurrentUser
                    post.likesCount = likesCount
                    post.commentsCount = commentsCount
                    completion(post)
                }
            }
        }
    }

    func fetchHomePosts(forCurrentUser currentUid: String, completion: @escaping ([Post]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var postsData: [Post] = []
        let startTime = Date()

        userFollowingRef.document(currentUid).getDocument { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion([])
                return
            }

            dictionary.forEach { (otherUid, _) in
                dispatchGroup.enter()
                self.fetchPosts(forUser: otherUid) { posts in
                    postsData.append(contentsOf: posts)
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("DEBUG: fetch home posts \(Date().timeIntervalSince(startTime))")
                completion(postsData)
            }
        }
    }

    func fetchLikedUser(forPost postId: String, completion: @escaping ([User]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var usersData: [User] = []

        postLikesRef.document(postId).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion([])
                return
            }

            for (index, (uid, _)) in dictionary.enumerated() {
                if index > 50 { break }
                dispatchGroup.enter()
                UserManager.shared.fetchUser(withUid: uid) { user, _ in
                    if let user = user {
                        usersData.append(user)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(usersData)
            }
        }
    }

    func likePost(_ postId: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        postLikesRef.document(postId).setData([currentUid : 1], merge: true) { error in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func unlikePost(_ postId: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        postLikesRef.document(postId).updateData([currentUid : FieldValue.delete()]) { error in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    // MARK: - Private functions

    private func fetchPosts(forUser uid: String, completion: @escaping ([Post]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var postsData: [Post] = []

        userPostsRef.document(uid).collection("posts").getDocuments { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let documents = querySnapshot?.documents, error == nil else {
                completion([])
                return
            }

            documents.forEach { document in
                let postId = document.documentID

                dispatchGroup.enter()
                self.fetchPost(postId) { post in
                    if let post = post {
                        postsData.append(post)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(postsData)
            }
        }
    }

    private func checkLikeStateForPost(_ postId: String, completion: @escaping (_ likesCount: Int, _ likedByCurrentUser: Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        postLikesRef.document(postId).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(0, false)
                return
            }

            if dictionary.count == 0 {
                completion(0, false)
                return
            }

            if dictionary[currentUid] == nil {
                completion(dictionary.count, false)
            } else {
                completion(dictionary.count, true)
            }
        }
    }

    private func numberOfComments(forPost postId: String, completion: @escaping (Int) -> Void) {
        let countQuery = postCommentsRef.document(postId).collection(Firebase.Post.comments).count

        countQuery.getAggregation(source: .server) { snapshot, error in
            guard let count = snapshot?.count as? Int, error == nil else {
                completion(0)
                return
            }
            completion(count)
        }
    }

}
