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

    var user: User
    var likesCount: Int = 0
    var commentsCount: Int = 0
    var likedByCurrentUser: Bool = false
}

extension Post {
    init(user: User, dictionary: [String: Any]) {
        let postId = dictionary[Firebase.Post.postId] as? String ?? ""
        let caption = dictionary[Firebase.Post.caption] as? String ?? ""
        let imageUrl = dictionary[Firebase.Post.imageUrl] as? String ?? ""
        let aspectRatio = dictionary[Firebase.Post.aspectRatio] as? Double ?? 0
        let timestamp = dictionary[Firebase.Post.creationDate] as? Timestamp ?? Timestamp()

        self.init(postId: postId, caption: caption,
                  imageUrl: imageUrl, aspectRatio: aspectRatio,
                  creationDate: timestamp.dateValue(), user: user)
    }
}
