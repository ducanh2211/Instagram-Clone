//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/06/2023.
//

import Foundation
import FirebaseAuth

enum ProfileType {
    case mainTabBar(currentUser: User)
    case other(currentUser: User, otherUser: User?)
}

class ProfileViewModel {

    var type: ProfileType
    var currentUser: User
    var otherUser: User?
    var isCurrentUser: Bool
    var fetchCurrentUserSuccess: (() -> Void)?
    var fetchBothUsersSucess: (() -> Void)?

    init(type: ProfileType) {
        self.type = type
        switch type {
            case .mainTabBar(let currentUser):
                isCurrentUser = true
                self.currentUser = currentUser
            case .other(let currentUser, let otherUser):
                isCurrentUser = otherUser == nil ? true : false
                self.currentUser = currentUser
                self.otherUser = otherUser
        }
    }

    func fetchCurrentUser() {
        fetchUser(uid: currentUser.uid) { [weak self] user in
            self?.currentUser = user
            DispatchQueue.main.async {
                Thread.sleep(forTimeInterval: 2)
                self?.fetchCurrentUserSuccess?()
            }
        }
    }

    private func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        UserManager.shared.fetchUser(withUid: uid) { user, error in
            if let user = user {
                completion(user)
            }
        }
    }

    private func fetchBothUsers() {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        fetchUser(uid: currentUser.uid) { [weak self] currentUser in
            self?.currentUser = currentUser
            dispatchGroup.leave()
        }

        if let otherUser = otherUser {
            dispatchGroup.enter()
            fetchUser(uid: otherUser.uid) { [weak self] otherUser in
                self?.otherUser = otherUser
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.fetchBothUsersSucess?()
        }
    }
}
