//
//  NewPostViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 25/04/2023.
//

import Foundation
import Photos

class NewPostViewModel {

    var isLoading: Bool = false {
        didSet { loadingIndicator?() }
    }
    var loadingIndicator: (() -> Void)?
    var createPostSuccess: (() -> Void)?
    var createPostFailure: ((Error) -> Void)?

    deinit {
        print("DEBUG: NewPostViewModel deinit")
    }

    func createPost(withImage imageData: Data,
                    aspectRatio: Double, caption: String) {
        isLoading = true

        PostManager.shared.createPost(withImage: imageData, imageAspectRatio: aspectRatio, caption: caption) { [weak self] error in
            guard let self = self else { return }
            self.isLoading = false
            if let error = error {
                self.createPostFailure?(error)
                return
            }
            self.createPostSuccess?()
        }
    }

}
