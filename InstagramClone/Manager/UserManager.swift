//
//  UserManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserManager {

    static let shared: UserManager = UserManager()

    private let db: Firestore = .firestore()

    private lazy var usersRef: CollectionReference = {
        db.collection(Firebase.RootCollection.users)
    }()
    private lazy var userFollowingRef: CollectionReference = {
        db.collection(Firebase.RootCollection.userFollowing)
    }()
    private lazy var userFollowersRef: CollectionReference = {
        db.collection(Firebase.RootCollection.userFollowers)
    }()
    private lazy var userPostsRef: CollectionReference = {
        db.collection(Firebase.RootCollection.userPosts)
    }()

    deinit {
        print("UserManager deinit")
    }

    /// - Note: Completion  being invoked from background thread.
    func uploadUser(_ user: User, completion: @escaping (User?, Error?) -> Void) {
        usersRef.document(user.uid).setData(user.description) { error in
            guard error == nil else {
                completion(nil, error)
                return
            }

            completion(user, nil)
        }
    }

    /// - Note: Completion  being invoked from background thread.
    func fetchUser(withUid uid: String, completion: @escaping (User?, Error?) -> Void) {
        usersRef.document(uid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(nil, error)
                return
            }

            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }

    func checkIfLoggedInUser(uid: String) -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        return currentUid == uid
    }

    func updateUserInfo(_ user: User, image: UIImage?,
                        updateAvatarOnly: Bool, completion: @escaping (Error?) -> Void) {
        var newData: [String: Any] = [:]

        if let image = image, let avatarData = image.jpegData(compressionQuality: 0.3) {
            StorageManager.shared.uploadUserAvatar(avatarData, folderName: user.uid) { imageUrl, error in
                guard let imageUrl = imageUrl, error == nil else {
                    completion(error)
                    return
                }

                if updateAvatarOnly {
                    newData = [Firebase.User.avatarUrl: imageUrl]
                } else {
                    newData = [
                        Firebase.User.fullName: user.fullName,
                        Firebase.User.userName: user.userName,
                        Firebase.User.bio: user.bio,
                        Firebase.User.avatarUrl: imageUrl
                    ]
                }
                self.usersRef.document(user.uid).updateData(newData, completion: completion)
            }
        }
        else {
            newData = [
                Firebase.User.fullName: user.fullName,
                Firebase.User.userName: user.userName,
                Firebase.User.bio: user.bio,
            ]
            usersRef.document(user.uid).updateData(newData, completion: completion)
        }
    }

    func searchUser(with query: String, completion: @escaping ([User]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        var usersData: [User] = []
        let dispatchGroup = DispatchGroup()

        usersRef.whereField(Firebase.User.uid, notIn: [currentUid]).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else {
                completion([])
                return
            }

            documents.forEach { document in
                dispatchGroup.enter()
                let dictionary = document.data()
                let uid = document.documentID

                guard let userName = dictionary[Firebase.User.userName] as? String,
                      userName.lowercased().contains(query)
                else {
                    dispatchGroup.leave()
                    return
                }

                self.fetchUser(withUid: uid) { user, error in
                    guard let user = user, error == nil else {
                        dispatchGroup.leave()
                        return
                    }
                    usersData.append(user)
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(usersData)
            }
        }
    }

    func checkFollowState(withOtherUser otherUserUid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        userFollowingRef.document(currentUid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(false)
                return
            }

            if dictionary[otherUserUid] == nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    func followUser(otherUid: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        userFollowingRef.document(currentUid).setData([otherUid : 1], merge: true) { error in
            guard error == nil else {
                completion(error)
                return
            }

            self.userFollowersRef.document(otherUid).setData([currentUid : 1], merge: true) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }

    func unfollowUser(otherUid: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }

        userFollowingRef.document(currentUid).updateData([otherUid : FieldValue.delete()]) { error in
            guard error == nil else {
                completion(error)
                return
            }

            self.userFollowersRef.document(otherUid).updateData([currentUid : FieldValue.delete()]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }

    func numberOfPost(forUser uid: String, completion: @escaping (Int) -> Void) {
        userPostsRef.document(uid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(0)
                return
            }
            completion(dictionary.count)
        }
    }

    func numberOfFollowing(forUser uid: String, completion: @escaping (Int) -> Void) {
        userFollowingRef.document(uid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(0)
                return
            }
            completion(dictionary.count)
        }
    }

    func numberOfFollowers(forUser uid: String, completion: @escaping (Int) -> Void) {
        userFollowersRef.document(uid).getDocument { documentSnapshot, error in
            guard let dictionary = documentSnapshot?.data(), error == nil else {
                completion(0)
                return
            }
            completion(dictionary.count)
        }
    }

}

