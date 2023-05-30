//
//  Comment.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 28/05/2023.
//

import Foundation
import FirebaseFirestore

struct Comment {
    var commentId: String
    var content: String
    var creationDate: Date

    var user: User
}

extension Comment {
    init(user: User, dictionary: [String: Any]) {
        let commentId = dictionary[Firebase.Comment.commentId] as? String ?? ""
        let content = dictionary[Firebase.Comment.content] as? String ?? ""
        let timestamp = dictionary[Firebase.Post.creationDate] as? Timestamp ?? Timestamp()

        self.init(commentId: commentId, content: content, creationDate: timestamp.dateValue(), user: user)
    }
}
