//
//  User.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import FirebaseAuth

struct User {
    var uid: String
    var email: String
    var fullName: String
    var userName: String
    var avatarUrl: String = ""
    var bio: String = ""
}

extension User {
    init(dictionary: [String : Any]) {
        let uid = dictionary["uid"] as? String ?? ""
        let email = dictionary["email"] as? String ?? ""
        let fullName = dictionary["full_name"] as? String ?? ""
        let userName = dictionary["user_name"] as? String ?? ""
        let avatarUrl = dictionary["avatar_url"] as? String ?? ""
        let bio = dictionary["bio"] as? String ?? ""

        self.init(uid: uid, email: email, fullName: fullName, userName: userName, avatarUrl: avatarUrl, bio: bio)
    }

    var description: [String : Any] {
        return [
            "uid": uid,
            "email": email,
            "full_name": fullName,
            "user_name": userName,
            "avatar_url": avatarUrl,
            "bio": bio
        ]
    }
}
