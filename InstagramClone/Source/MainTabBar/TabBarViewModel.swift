//
//  TabBarViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/04/2023.
//

import Foundation
import FirebaseAuth

class TabBarViewModel {

    private let auth: Auth = .auth()
    var user: User?
    var receivedUser: (() -> Void)?

    var userAlreadyLogIn: Bool {
        auth.currentUser == nil ? false : true
    }

    init() {
        self.fetchUser()
    }

    func fetchUser() {
        guard userAlreadyLogIn else { return }
        let uid = auth.currentUser!.uid

        UserManager.shared.fetchUser(withUid: uid) { [weak self] user , error in
            guard error == nil else { return }
            self?.user = user
            DispatchQueue.main.async {
                self?.receivedUser?()
            }
        }
    }
}
