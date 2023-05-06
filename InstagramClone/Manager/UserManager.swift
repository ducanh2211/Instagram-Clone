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
    print("UserManager deinit")
  }
  
  /// - Note: Completion  being invoked from background thread.
  func uploadUser(_ user: User,
                  completion: @escaping (User?, Error?) -> Void) {
    
    collectionUsersRef.document(user.uid).setData(user.description) { error in
      guard error == nil else {
        completion(nil, error)
        return
      }
      
      
        completion(user, nil)
      
    }
  }
  
  /// - Note: Completion  being invoked from background thread.
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
      
        print("DEBUG: completion with USER")
        completion(user, nil)
      
    }
  }
}
