//
//  TabBarViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/04/2023.
//

import Foundation
import FirebaseAuth

class TabBarViewModel {
  
  // MARK: private
  private let auth: Auth
  private let userManager: UserManager
  
  init(auth: Auth = .auth(),
       userManager: UserManager = .init()) {
    
    self.auth = auth
    self.userManager = userManager
    print("DEBUG: init tab bar view model")
    self.fetchUser()
  }
  
  // MARK: public
  var user: User?
  var receivedUser: (() -> Void)?
  
  var isUserAlreadyLogIn: Bool {
    auth.currentUser == nil ? false : true
  }
  
  func fetchUser() {
    guard isUserAlreadyLogIn else { return }
    let uid = auth.currentUser!.uid
    userManager.fetchUser(withUid: uid) { user in
      print("DEBUG: fetch user da den")
      self.user = user
      self.receivedUser?()
    }
  }
  
}
