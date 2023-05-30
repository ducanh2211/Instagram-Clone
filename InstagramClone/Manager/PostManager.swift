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
    private let db: Firestore = .firestore()
    private let auth: Auth = .auth()

    private lazy var postsRef: CollectionReference = {
        db.collection(Firebase.RootCollection.posts)
    }()
    private lazy var postLikesRef: CollectionReference = {
        db.collection(Firebase.RootCollection.postLikes)
    }()
    private lazy var postCommentsRef: CollectionReference = {
        db.collection(Firebase.RootCollection.postComments)
    }()
    private lazy var commentsRef: CollectionReference = {
        db.collection(Firebase.RootCollection.comments)
    }()
    private lazy var userPostsRef: CollectionReference = {
        db.collection(Firebase.RootCollection.userPosts)
    }()
    private lazy var userFollowingRef: CollectionReference = {
        db.collection(Firebase.RootCollection.userFollowing)
    }()

    deinit {
        print("Post Manager deinit")
    }

    // MARK: - Public funtions

    func createPost(withImage imageData: Data, imageAspectRatio aspectRatio: Double,
                    caption: String, completion: @escaping (Error?) -> Void) {

        guard let currentUid = auth.currentUser?.uid else { return }
        let postRef = postsRef.document()
        let postId = postRef.documentID

        StorageManager.shared.uploadPostImage(imageData, folderName: postId) { imageUrl, error in
            guard error == nil else {
                completion(error)
                return
            }

            let postData: [String: Any] = [
                Firebase.Post.postId: postId,
                Firebase.Post.caption: caption,
                Firebase.Post.imageUrl: imageUrl!,
                Firebase.Post.aspectRatio: aspectRatio,
                Firebase.Post.creationDate: Date(),
                Firebase.Post.uid: currentUid
            ]

            postRef.setData(postData) { error in
                guard error == nil else {
                    completion(error)
                    return
                }

                self.userPostsRef.document(currentUid).setData([postId : 1], merge: true) { error in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    completion(nil)
                }

            }
        }
    }

    func fetchPosts(forUser uid: String, completion: @escaping ([Post]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var postsData: [Post] = []
        let startTime = Date()
        userPostsRef.document(uid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion([])
                return
            }

            dictionary.forEach { (postId, _) in
                dispatchGroup.enter()
                self.fetchPost(postId) { post in
                    if let post = post {
                        postsData.append(post)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("DEBUG: fetch posts \(Date().timeIntervalSince(startTime))")
                completion(postsData)
            }
        }
    }

    func fetchHomePosts(forCurrentUser currentUid: String, completion: @escaping ([Post]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var postsData: [Post] = []
        let startTime = Date()

        userFollowingRef.document(currentUid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion([])
                return
            }
            print("DEBUG: fetch home posts \(Thread.current)")
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

    func fetchExplorePosts(completion: @escaping ([Post]) -> Void) {
        guard let currentUid = auth.currentUser?.uid else { return }

        let dispatchGroup = DispatchGroup()
        let startTime = Date()

        postsRef.whereField(Firebase.Post.uid, notIn: [currentUid]).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            var postsData: [Post] = []

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
                print("DEBUG: fetch all posts \(Date().timeIntervalSince(startTime))")
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

    func sendComment(toPost postId: String, content: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = auth.currentUser?.uid else { return }
        let commentRef = commentsRef.document()
        let commentId = commentRef.documentID

        let commentData: [String: Any] = [
            Firebase.Comment.commentId: commentId,
            Firebase.Comment.content: content,
            Firebase.Post.creationDate: Date(),
            Firebase.Post.uid: currentUid
        ]

        commentRef.setData(commentData) { error in
            guard error == nil else {
                completion(error)
                return
            }

            self.postCommentsRef.document(postId).setData([commentId : 1], merge: true) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }

    func fetchComments(forPost postId: String, completion: @escaping ([Comment]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var commentsData: [Comment] = []

        postCommentsRef.document(postId).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion([])
                return
            }
            
            dictionary.forEach { (commentId, _) in
                dispatchGroup.enter()
                self.fetchComment(commentId) { comment in
                    if let comment = comment {
                        commentsData.append(comment)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(commentsData)
            }
        }
    }

    func likePost(_ postId: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = auth.currentUser?.uid else { return }

        postLikesRef.document(postId).setData([currentUid : 1], merge: true) { error in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    func unlikePost(_ postId: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = auth.currentUser?.uid else { return }

        postLikesRef.document(postId).updateData([currentUid : FieldValue.delete()]) { error in
            guard error == nil else {
                completion(error)
                return
            }
            completion(nil)
        }
    }

    // MARK: - Private functions

    private func fetchPost(_ postId: String, completion: @escaping (Post?) -> Void) {
        postsRef.document(postId).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            guard let uid = dictionary[Firebase.Post.uid] as? String else {
                completion(nil)
                return
            }

            UserManager.shared.fetchUser(withUid: uid) { user, error in
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
    }

    private func fetchComment(_ commentId: String, completion: @escaping (Comment?) -> Void) {
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

    private func checkLikeStateForPost(_ postId: String, completion: @escaping (_ likesCount: Int, _ likedByCurrentUser: Bool) -> Void) {
        guard let currentUid = auth.currentUser?.uid else { return }

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
        postCommentsRef.document(postId).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(0)
                return
            }
            completion(dictionary.count)
        }
    }

}
