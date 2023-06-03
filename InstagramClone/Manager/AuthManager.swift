//
//  AuthManager.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseAuth

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

    static let shared: AuthManager = AuthManager()

    private let auth: Auth = .auth()

    deinit {
        print("DEBUG: AuthManager deinit")
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

        // completion call on main thread
        auth.createUser(withEmail: email, password: password) { auth, error in
            if let error = error {
                completion(nil, .otherError(error))
                return
            }
            let uid = auth!.user.uid
            let user = User(uid: uid, email: email, fullName: fullName, userName: userName)

            // completion call on background thread
            UserManager.shared.uploadUser(user) { user, error in
                if let error = error {
                    completion(nil, .otherError(error))
                    return
                }
                completion(user, nil)
            }
        }
    }

    func logInUser(email: String, password: String, completion: @escaping (User?, AuthError?) -> Void) {
        auth.signIn(withEmail: email, password: password) { auth, error in
            if let error = error {
                completion(nil, .otherError(error))
                return
            }
            let uid = auth!.user.uid

            // completion call on background thread
            UserManager.shared.fetchUser(withUid: uid) { user, error in
                guard let user = user else {
                    completion(nil, .otherError(error!))
                    return
                }
                completion(user, nil)
            }
        }
    }

}

