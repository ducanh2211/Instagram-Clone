//
//  AuthManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthError: Error {
  case fullNameError
  case userNameError
  case otherError(Error)
  
  var description: String {
    switch self {
      case .fullNameError:
        return "Full name must have at least 6 characters."
      case .userNameError:
        return "User name must have at least 6 characters."
      case .otherError(let error):
        return error.localizedDescription
    }
  }
}

class AuthManager {
  
  private let auth: Auth
  private let userManager: UserManager
  private let storageManager: StorageManager
  
  deinit {
    print("Auth Manager deinit")
  }
  
  init(auth: Auth = .auth(),
       userManager: UserManager = .init(),
       storageManager: StorageManager = .init()) {
    self.auth = auth
    self.userManager = userManager
    self.storageManager = storageManager
  }
  
  func createUser(email: String, password: String,
                  fullName: String, userName: String,
                  completion: @escaping (User?, AuthError?) -> Void) {

    guard fullName.count >= 6 else {
      completion(nil, .fullNameError)
      return
    }
    guard userName.count >= 6 else {
      completion(nil, .userNameError)
      return
    }
    
    auth.createUser(withEmail: email, password: password) { [weak self] auth, error in
      guard let self = self else { return }

      guard error == nil else {
        completion(nil, .otherError(error!))
        return
      }
      let avatarImage = self.defaultAvatar()
      let uid = auth!.user.uid
      
      self.storageManager.uploadUserAvatar(avatarImage) { avatarUrl in
        guard let avatarUrl = avatarUrl else { return }
        let userData = User(uid: uid, email: email, fullName: fullName,
                            userName: userName, avatarUrl: avatarUrl)
        
        self.userManager.uploadUser(userData, email: email, fullName: fullName, userName: userName, avatarUrl: avatarUrl, completion: completion)
//        self.uploadUser(userData, email: email,
//                        fullName: fullName, userName: userName,
//                        avatarUrl: avatarUrl, completion: completion)
      }
    }
  }
  
  func logInUser(email: String, password: String,
                  completion: @escaping (User?, AuthError?) -> Void) {
    
    auth.signIn(withEmail: email, password: password) { auth, error in
      guard error == nil else {
        completion(nil, .otherError(error!))
        return
      }
      let uid = auth!.user.uid
      self.userManager.fetchUser(withUid: uid) { user in
        completion(user, nil)
      }
//      self.fetchUser() {}
    }
  }
  
  // MARK: - Private functions
//  private func uploadUser(_ user: User, email: String,
//                          fullName: String, userName: String,
//                          avatarUrl: String, completion: @escaping (User?, AuthError?) -> Void) {
//
//    db.collection(Constants.Firebase.USER_REF)
//      .document(user.uid)
//      .setData(user.description) { error in
//        guard error == nil else {
//          completion(nil, .otherError(error!))
//          return
//        }
//        completion(user, nil)
//      }
//  }
//
//  private func fetchUser(withUid uid: String,
//                         completion: @escaping (User?) -> Void) {
//
//    db.collection(Constants.Firebase.USER_REF)
//      .document(uid)
//      .getDocument { documentSnapshot, error in
//        guard error == nil else {
//          completion(nil)
//          return
//        }
//        guard let dictionary = documentSnapshot!.data() else { return }
//        let user = User(dictionary: dictionary)
//        completion(user)
//      }
//  }
  
  private func defaultAvatar() -> UIImage {
    return UIImage(systemName: "person.fill")!
  }
}

