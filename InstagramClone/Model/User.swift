//
//  User.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation

struct User {
  var uid: String
  var email: String
  var fullName: String
  var userName: String
  var avatarUrl: String
  var postsCount: Int = 0
  var followersCount: Int = 0
  var followingCount: Int = 0
}

extension User: FirebaseModel {
  init?(dictionary: [String : Any]) {
    guard let uid = dictionary["uid"] as? String,
          let email = dictionary["email"] as? String,
          let fullName = dictionary["fullName"] as? String,
          let userName = dictionary["userName"] as? String,
          let avatarUrl = dictionary["avatarUrl"] as? String,
          let postsCount = dictionary["postsCount"] as? Int,
          let followersCount = dictionary["followersCount"] as? Int,
          let followingCount = dictionary["followingCount"] as? Int
    else {
      return nil
    }

    self.init(uid: uid, email: email,
              fullName: fullName, userName: userName,
              avatarUrl: avatarUrl, postsCount: postsCount,
              followersCount: followersCount, followingCount: followingCount)
  }
  
  var description: [String : Any] {
    return [
      "uid": uid,
      "email": email,
      "fullName": fullName,
      "userName": userName,
      "avatarUrl": avatarUrl,
      "postsCount": postsCount,
      "followersCount": followersCount,
      "followingCount": followingCount
    ]
  }
}
