//
//  DataPersistenceManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/04/2023.
//

import Foundation

class DataPersistenceManager {
  
  enum Key: String {
    case currentUser = "current_user"
  }
  
  private let userDefaults: UserDefaults
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  func save(model: User) {
    
  }
}
