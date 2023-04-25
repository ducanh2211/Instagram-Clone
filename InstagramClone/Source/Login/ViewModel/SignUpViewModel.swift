//
//  SignUpViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation

class SignUpViewModel {
  
  var user: User? {
    didSet { success?() }
  }
  var isLoading: Bool = false {
    didSet { loadingIndicator?() }
  }
  var errorMessage: String = "" {
    didSet { failure?() }
  }
  var success: (() -> Void)?
  var failure: (() -> Void)?
  var loadingIndicator: (() -> Void)?
  
  private let authManager: AuthManager
  
  init(authManager: AuthManager = .init()) {
    self.authManager = authManager
  }
  
  deinit {
    print("Signup View Model deinit")
  }
  
  func signUpUser(email: String, password: String,
                  fullName: String, username: String) {
    
    isLoading = true
    authManager.createUser(email: email, password: password,
                             fullName: fullName, userName: username) { [weak self] user, error in
      guard let self = self else { return }
      self.isLoading = false
      if let error = error {
        self.errorMessage = error.description
        return
      }
      self.user = user
    }
  }
  
}
