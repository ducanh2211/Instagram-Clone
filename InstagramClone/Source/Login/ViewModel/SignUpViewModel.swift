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

    deinit {
        print("SignupViewModel deinit")
    }

    func signUpUser(email: String, password: String,
                    fullName: String, username: String) {
        isLoading = true

        // completion perhaps call on background thread
        AuthManager.shared.createUser(email: email, password: password,
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
