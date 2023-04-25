//
//  Post.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 25/04/2023.
//

import Foundation
import FirebaseFirestore

struct Post {
  var postId: String
  var caption: String
  var imageUrl: String
  var aspectRatio: Double
  var creationDate: Date
  var uid: String
  var likesCount: Int = 0
  var commentsCount: Int = 0
  
  var user: User! = nil
}

extension Post: FirebaseModel {
  init?(dictionary: [String : Any]) {
    guard let postId = dictionary["post_id"] as? String,
          let caption = dictionary["caption"] as? String,
          let imageUrl = dictionary["image_url"] as? String,
          let aspectRatio = dictionary["aspect_ratio"] as? Double,
          let timestamp = dictionary["creation_date"] as? Timestamp,
          let uid = dictionary["uid"] as? String,
          let likesCount = dictionary["likes_count"] as? Int,
          let commentsCount = dictionary["comments_count"] as? Int
    else {
      return nil
    }
    
    self.init(postId: postId, caption: caption,
              imageUrl: imageUrl, aspectRatio: aspectRatio,
              creationDate: timestamp.dateValue(), uid: uid,
              likesCount: likesCount, commentsCount: commentsCount)
  }
  
  init?(user: User, dictionary: [String: Any]) {
    self.init(dictionary: dictionary)
    self.user = user
  }
  
  var description: [String : Any] {
    [
      "post_id": postId,
      "caption": caption,
      "image_url": imageUrl,
      "aspect_ratio": aspectRatio,
      "creation_date": Timestamp(date: creationDate),
      "uid": uid,
      "likes_count": likesCount,
      "comments_count": commentsCount
    ]
  }
}
