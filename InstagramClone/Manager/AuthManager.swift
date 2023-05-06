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
    print("AuthManager deinit")
  }
  
  init(auth: Auth = .auth(),
       userManager: UserManager = UserManager(),
       storageManager: StorageManager = StorageManager()) {
    
    self.auth = auth
    self.userManager = userManager
    self.storageManager = storageManager
  }
  
  // MARK: - Public funtions
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
    
    // completion call on main thread
    auth.createUser(withEmail: email, password: password) { [weak self] auth, error in
      guard let self = self else { return }

      if let error = error {
        completion(nil, .otherError(error))
        return
      }
      
      guard let avatarImageData = self.defaultAvatar().jpegData(compressionQuality: 0.3) else { return }
      let uid = auth!.user.uid
      
      // completion call on main thread
      self.storageManager.uploadUserAvatar(avatarImageData, folderName: uid) { imageUrl, error in
        if let error = error {
          completion(nil, .otherError(error))
          return
        }
        
        let user = User(uid: uid, email: email, fullName: fullName,
                            userName: userName, avatarUrl: imageUrl!)
        
        // completion call on background thread
        self.userManager.uploadUser(user) { user, error in
          if let error = error {
            completion(nil, .otherError(error))
            return
          }
          
          completion(user, nil)
        }
      }
    }
  }
  
  func logInUser(email: String, password: String,
                  completion: @escaping (User?, AuthError?) -> Void) {
    
    auth.signIn(withEmail: email, password: password) { [weak self] auth, error in
      guard let self = self else { return }
      
      if let error = error {
        completion(nil, .otherError(error))
        return
      }
      
      let uid = auth!.user.uid
      
      // completion call on background thread
      self.userManager.fetchUser(withUid: uid) { user, error in
        if let error = error {
          completion(nil, .otherError(error))
          return
        }
        
        completion(user, nil)
      }
    }
  }
  
  // MARK: - Private functions
  private func defaultAvatar() -> UIImage {
    return UIImage(systemName: "person.fill")!
  }
}

