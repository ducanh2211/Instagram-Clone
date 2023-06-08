//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation

class LoginViewModel {

    var user: User? {
        didSet { fetchUserSuccess?() }
    }
    var isLoading: Bool = false {
        didSet { handleLoadingIndicator?() }
    }
    var errorMessage: String = "" {
        didSet { fetchUserFailure?() }
    }
    var fetchUserSuccess: (() -> Void)?
    var fetchUserFailure: (() -> Void)?
    var handleLoadingIndicator: (() -> Void)?
    
    deinit {
        print("DEBUG: LoginViewModel deinit")
    }

    func logInUser(email: String, password: String) {
        isLoading = true

        // completion perhaps call on background thread
        AuthManager.shared.logInUser(email: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.description
                    return
                }
                self.user = user
            }
        }
    }
}
