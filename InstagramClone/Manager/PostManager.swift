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
  private let db: Firestore
  private let auth: Auth
  private let storageManager: StorageManager
  
  private lazy var collcetionPostsRef: CollectionReference = {
    db.collection(Constants.Firebase.POST_REF)
  }()
  
  private lazy var collectionUserPostsRef: CollectionReference = {
    db.collection(Constants.Firebase.USER_POST_REF)
  }()
  
  init(db: Firestore = .firestore(),
       auth: Auth = .auth(),
       storageManager: StorageManager = StorageManager()) {
    
    self.db = db
    self.auth = auth
    self.storageManager = storageManager
  }
  
  deinit {
    print("Post Manager deinit")
  }
  
  // MARK: - Public funtions
  func createPost(withImage imageData: Data,
                  imageAspectRatio aspectRatio: Double,
                  caption: String,
                  completion: @escaping (Error?) -> Void) {
    
    guard let currentUid = auth.currentUser?.uid else { return }
    let postRef = collcetionPostsRef.document()
    let postId = postRef.documentID
    
    storageManager.uploadPostImage(imageData, folderName: postId) { imageUrl, error in
      print("POST MANAGER - upload post ON THREAD: \(Thread.current)")
      guard error == nil else {
        completion(error)
        return
      }
      
      let postData = Post(postId: postId, caption: caption,
                          imageUrl: imageUrl!, aspectRatio: aspectRatio,
                          creationDate: Date(), uid: currentUid)
      
      postRef.setData(postData.description) { error in
        print("POST MANAGER - database ON THREAD: \(Thread.current)")
        guard error == nil else {
          completion(error)
          return
        }
        
        self.collectionUserPostsRef.document(currentUid).setData([postId : 1], merge: true) { error in
          print("POST MANAGER - database ON THREAD: \(Thread.current)")
            guard error == nil else {
              completion(error)
              return
            }
            
            completion(nil)
          }
      }
    }
  }
  
}
