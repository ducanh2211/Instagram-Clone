//
//  UserManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

class UserManager {
  
  private let db: Firestore
  
  private lazy var collectionUsersRef: CollectionReference = {
    db.collection(Constants.Firebase.USER_REF)
  }()
  
  init(db: Firestore = .firestore(),
       queue: DispatchQueue = DispatchQueue(label: "my.firestore.queue")) {
    
    let setting = FirestoreSettings()
    setting.dispatchQueue = queue
    db.settings = setting
    
    self.db = db
  }
  
  deinit {
    print("User Manager deinit")
  }
  
  func uploadUser(_ user: User, email: String,
                  fullName: String, userName: String,
                  avatarUrl: String, completion: @escaping (User?, Error?) -> Void) {
    
    collectionUsersRef.document(user.uid).setData(user.description) { error in
      guard error == nil else {
        completion(nil, error)
        return
      }
      
      DispatchQueue.main.async {
        completion(user, nil)
      }
    }
  }
  
  func fetchUser(withUid uid: String,
                 completion: @escaping (User?, Error?) -> Void) {
    
    collectionUsersRef.document(uid).getDocument { documentSnapshot, error in
      print("Fetch user thread: \(Thread.current)")
      guard error == nil else {
        completion(nil, error)
        return
      }
      
      guard let dictionary = documentSnapshot!.data() else {
        completion(nil, error)
        return
      }
      
      let user = User(dictionary: dictionary)
      DispatchQueue.main.async {
        print("DEBUG: completion with USER")
        completion(user, nil)
      }
    }
  }
}
