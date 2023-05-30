//
//  ProfileEditViewController + Delegate.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 22/05/2023.
//

import UIKit
import PhotosUI

// MARK: - ProfileEditHeaderDelegate

extension ProfileEditController: ProfileEditHeaderDelegate {
    func didTapEditAvatarButton() {
        self.presentEditAvatarSheet()
    }

    func didTapAvatarImage() {
        self.presentEditAvatarSheet()
    }

    private func presentEditAvatarSheet() {
        let vc = ProfileEditAvatarSheetController(profileImageString: user.avatarUrl)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false) {
            vc.showSheet()
        }
    }
}

// MARK: - ProfileEditAvatarSheetControllerDelegate

extension ProfileEditController: ProfileEditAvatarSheetControllerDelegate {
    func didSelectOption(_ sheetController: ProfileEditAvatarSheetController,
                         option: ProfileEditAvatarSheetController.Options) {

        sheetController.removeSheet() {
            switch option {
                case .photo:
                    var config = PHPickerConfiguration()
                    config.selectionLimit = 1
                    let picker = PHPickerViewController(configuration: config)
                    picker.delegate = self
                    picker.modalPresentationStyle = .fullScreen
                    self.present(picker, animated: true)
                case .camera:
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    self.present(picker, animated: true)
            }
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ProfileEditController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let items = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }

        items.forEach { item in
            item.loadObject(ofClass: UIImage.self) { image, _ in
                guard let image = image as? UIImage else { return }

                ImageCompressor.compress(image: image, maxByte: 1000000) { compressedImage in
                    DispatchQueue.main.async {
                        self.selectedImage = compressedImage
                    }
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }

        ImageCompressor.compress(image: image, maxByte: 1000000) { compressedImage in
            DispatchQueue.main.async {
                self.selectedImage = compressedImage
            }
        }

        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - ProfileEditDetailControllerDelegate

extension ProfileEditController: ProfileEditDetailControllerDelegate {
    func userInfoDidChange(with newInfo: UserInfoData) {
        self.shouldUpdateOtherInfo = true

        switch newInfo.type {
            case .name:
                user.fullName = newInfo.data
            case .userName:
                user.userName = newInfo.data
            case .bio:
                user.bio = newInfo.data
        }

        self.dataSource = [
            .init(type: .name, data: user.fullName),
            .init(type: .userName, data: user.userName),
            .init(type: .bio, data: user.bio)
        ]
    }
}
