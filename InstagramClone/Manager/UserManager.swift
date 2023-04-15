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
  
  init(db: Firestore = .firestore(),
       queue: DispatchQueue = .init(label: "my.concurrent.queue")) {
    self.db = db
    let setting = FirestoreSettings()
    setting.dispatchQueue = queue
    self.db.settings = setting
  }
  
  deinit {
    print("User Manager deinit")
  }
  
  func uploadUser(_ user: User, email: String,
                  fullName: String, userName: String,
                  avatarUrl: String, completion: @escaping (User?, AuthError?) -> Void) {
    
    db.collection(Constants.Firebase.USER_REF)
      .document(user.uid)
      .setData(user.description) { error in
        print(Thread.current)
        guard error == nil else {
          completion(nil, .otherError(error!))
          return
        }
        DispatchQueue.main.async {
          completion(user, nil)
        }
      }
  }
  
  func fetchUser(withUid uid: String, completion: @escaping (User?) -> Void) {
    db.collection(Constants.Firebase.USER_REF)
      .document(uid)
      .getDocument { documentSnapshot, error in
        print(Thread.current)
        guard error == nil else {
          completion(nil)
          return
        }
        guard let dictionary = documentSnapshot!.data() else { return }
        let user = User(dictionary: dictionary)
        DispatchQueue.main.async {
          completion(user)
        }
      }
  }
}
