//
//  StorageManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseStorage

class StorageManager {

    static let shared: StorageManager = StorageManager()

    private let storage: Storage = Storage.storage()

    private lazy var avatarRef: StorageReference = {
//        storage.reference().child(Constants.Firebase.AVATAR_REF)
        storage.reference().child(Firebase.RootCollection.avatar)
    }()

    private lazy var postImagesRef: StorageReference = {
//        storage.reference().child(Constants.Firebase.POST_IMAGES_REF)
        storage.reference().child(Firebase.RootCollection.postImages)
    }()

    deinit {
        print("StorageManager deinit")
    }

    func uploadUserAvatar(_ imageData: Data, folderName: String,
                          completion: @escaping (_ imageUrl: String?, _ error: Error?) -> Void) {

        let imagePath = UUID().uuidString
        let userAvatarRef = avatarRef.child(folderName).child(imagePath)

        userAvatarRef.putData(imageData) { metadata, error in
            guard error == nil else {
                completion(nil, error)
                return
            }

            userAvatarRef.downloadURL { url, error in
                guard error == nil else {
                    completion(nil, error)
                    return
                }

                let avatarUrl = url!.absoluteString
                completion(avatarUrl, nil)
            }
        }
    }

    func uploadPostImage(_ imageData: Data, folderName: String,
                         completion: @escaping (_ imageUrl: String?, _ error: Error?) -> Void) {

        let imagePath = UUID().uuidString
        let imageRef = postImagesRef.child(folderName).child(imagePath)

        imageRef.putData(imageData) { metadata, error in
            print("STORAGE QUEUE 1: \(Thread.current)")
            guard error == nil else {
                completion(nil, error)
                return
            }

            imageRef.downloadURL { url, error in
                print("STORAGE QUEUE 2: \(Thread.current)")
                guard error == nil else {
                    completion(nil, error)
                    return
                }

                let imageUrl = url!.absoluteString
                completion(imageUrl, nil)
            }
        }
    }

}
