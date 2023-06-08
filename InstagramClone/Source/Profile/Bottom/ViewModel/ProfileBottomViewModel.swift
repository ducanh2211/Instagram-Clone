//
//  ProfileBottomViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 05/06/2023.
//

import Foundation

class ProfileBottomViewModel {

    var currentUser: User
    var otherUser: User?
    var isCurrentUser: Bool

    init(currentUser: User, otherUser: User?) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        self.isCurrentUser = otherUser != nil
    }

}
