//
//  Constants.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 15/04/2023.
//

import Foundation
import UIKit

enum Constants {
//    enum Firebase {
//        static let USER_REF = "users"
//        static let USER_POST_REF = "user-posts"
//        static let USER_FOLLOWING_REF = "user-following"
//        static let USER_FOLLOWERS_REF = "user-followers"
//        static let POST_REF = "posts"
//        static let POST_LIKES_REF = "post-likes"
//        static let POST_COMMENTS_REF = "post-comments"
//        static let AVATAR_REF = "profile-images"
//        static let POST_IMAGES_REF = "post-images"
//    }

    enum Color {
        static let royalBlue = UIColor(red: 5, green: 10, blue: 230, alpha: 1)
        static let blue = UIColor(red: 88, green: 81, blue: 216, alpha: 1)
        static let purple = UIColor(red: 131, green: 58, blue: 180, alpha: 1)
        static let darkPink = UIColor(red: 193, green: 53, blue: 132, alpha: 1)
        static let purpleRed = UIColor(red: 255, green: 48, blue: 108, alpha: 1)
        static let red = UIColor(red: 253, green: 36, blue: 76, alpha: 1)
        static let darkOrange = UIColor(red: 88, green: 81, blue: 216, alpha: 1)
        static let orange = UIColor(red: 247, green: 119, blue: 55, alpha: 1)
        static let yellow = UIColor(red: 252, green: 175, blue: 69, alpha: 1)
        static let lightYellow = UIColor(red: 255, green: 220, blue: 128, alpha: 1)
    }

//    enum Post {
//        static let postId = "post_id"
//        static let caption = "caption"
//        static let imageUrl = "image_url"
//        static let aspectRatio = "aspect_ratio"
//        static let creationDate = "creation_date"
//        static let uid = "uid"
//    }
//
//    enum User {
//        static let uid = "uid"
//        static let fullName = "full_name"
//        static let userName = "user_name"
//        static let email = "email"
//        static let bio = "bio"
//        static let avatarUrl = "avatar_url"
//    }
}

enum Firebase {
    enum RootCollection {
        static let users = "users"
        static let userPosts = "user-posts"
        static let userFollowing = "user-following"
        static let userFollowers = "user-followers"
        static let posts = "posts"
        static let postLikes = "post-likes"
        static let postComments = "post-comments"
        static let comments = "comments"
        static let avatar = "profile-images"
        static let postImages = "post-images"
    }

    enum Post {
        static let postId = "post_id"
        static let caption = "caption"
        static let imageUrl = "image_url"
        static let aspectRatio = "aspect_ratio"
        static let creationDate = "creation_date"
        static let uid = "uid"
    }

    enum User {
        static let uid = "uid"
        static let fullName = "full_name"
        static let userName = "user_name"
        static let email = "email"
        static let bio = "bio"
        static let avatarUrl = "avatar_url"
    }

    enum Comment {
        static let commentId = "comment_id"
        static let content = "content"
        static let creationDate = "creation_date"
        static let uid = "uid"
    }
}

enum PhotoConstants {
    enum Post {
        static let portraitAspectRatio: CGFloat = 3/4
        static let landscapeAspectRatio: CGFloat = 16/9
    }

    enum Profile {
        static let aspectRatio: CGFloat = 1/1
    }
}
