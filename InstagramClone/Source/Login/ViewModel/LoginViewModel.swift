//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation

class LoginViewModel {
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
  
  func logInUser(email: String, password: String) {
    isLoading = true
    authManager.logInUser(email: email, password: password) { [weak self] user, error in
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
