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
          let fullName = dictionary["full_name"] as? String,
          let userName = dictionary["user_name"] as? String,
          let avatarUrl = dictionary["avatar_url"] as? String,
          let postsCount = dictionary["posts_count"] as? Int,
          let followersCount = dictionary["followers_count"] as? Int,
          let followingCount = dictionary["following_count"] as? Int
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
      "full_name": fullName,
      "user_name": userName,
      "avatar_url": avatarUrl,
      "posts_count": postsCount,
      "followers_count": followersCount,
      "following_count": followingCount
    ]
  }
}
