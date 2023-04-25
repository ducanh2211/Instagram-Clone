//
//  NewPostViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 25/04/2023.
//

import Foundation

class NewPostViewModel {
  
  var isLoading: Bool = false {
    didSet { loadingIndicator?() }
  }
  var loadingIndicator: (() -> Void)?
  var createPostSuccess: (() -> Void)?
  var createPostFailure: ((Error) -> Void)?
  
  private let postManager: PostManager
  
  init(postManager: PostManager = PostManager()) {
    self.postManager = postManager
  }
  
  deinit {
    print("NewPostViewModel deinit")
  }
  
  func createPost(withImage imageData: Data,
                  aspectRatio: Double, caption: String) {
    isLoading = true
    postManager.createPost(withImage: imageData, imageAspectRatio: aspectRatio, caption: caption) { error in
      self.isLoading = false
      if let error = error {
        self.createPostFailure?(error)
        return
      }
      self.createPostSuccess?()
    }
  }
  
}
