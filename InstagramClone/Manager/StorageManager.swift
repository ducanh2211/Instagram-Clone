//
//  StorageManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageManager {
  
  private let storage: Storage
  
  init(storage: Storage = .storage()) {
    self.storage = storage
  }
  
  deinit {
    print("Storage Manager deinit")
  }
  
  func uploadUserAvatar(_ image: UIImage, completion: @escaping (String?) -> Void) {
    guard let data = image.jpegData(compressionQuality: 0.3) else { return }
    let imagePath = UUID().uuidString
    let avatarRef = storage.reference().child(Constants.Firebase.AVATAR_REF).child(imagePath)
    
    avatarRef.putData(data) { metadata, error in
      guard error == nil else {
        completion(nil)
        return
      }
      
      avatarRef.downloadURL { url, error in
        guard error == nil else {
          completion(nil)
          return
        }
        
        let avatarUrl = url!.absoluteString
        completion(avatarUrl)
      }
    }
  }
  
  
  
}
