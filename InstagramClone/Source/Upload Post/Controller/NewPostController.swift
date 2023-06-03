//
//  NewPostController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 23/04/2023.
//

import UIKit
import Photos

class NewPostController: UIViewController, CustomizableNavigationBar {

    // MARK: - UI components

    var navBar: CustomNavigationBar!
    var activityIndicator: UIActivityIndicatorView!

    lazy var smallPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPreviewPhoto))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    lazy var captionTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeHolderText = "Write a caption..."
        textView.delegate = self
        return textView
    }()

    lazy var previewPhotoView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.addSubview(largePhotoImageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removePreviewPhoto))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    let largePhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Properties

    private let viewModel = NewPostViewModel()
    private let asset: PHAsset
    private var postImage: UIImage?
    private let originAspectRatio: CGFloat
    private let idealPhotoResolution = CGSize(width: 1080, height: 1080)
    var captionTextViewHeightConstraint: NSLayoutConstraint!

    private var shouldCropImage: Bool {
        originAspectRatio < PhotoConstants.Post.portraitAspectRatio || originAspectRatio > PhotoConstants.Post.landscapeAspectRatio
    }

    lazy var idealPhotoAspectRatio: CGFloat = {
        if originAspectRatio < PhotoConstants.Post.portraitAspectRatio {
            return PhotoConstants.Post.portraitAspectRatio
        }
        else if originAspectRatio > PhotoConstants.Post.landscapeAspectRatio {
            return PhotoConstants.Post.landscapeAspectRatio
        }
        else {
            return originAspectRatio
        }
    }()

    // MARK: - Life cycle

    init(asset: PHAsset) {
        self.asset = asset
        self.originAspectRatio = CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("NewPostController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyBoardWhenTapped()
        bindViewModel()
        fetchImage()
        setupView()
    }

    // MARK: - Functions

    private func bindViewModel() {
        viewModel.createPostSuccess = { [weak self] in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .reloadUserProfileFeed, object: nil)
                self?.dismiss(animated: true)
            }
        }

        viewModel.createPostFailure = { [weak self] error in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }

        viewModel.loadingIndicator = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let isLoading = self.viewModel.isLoading
                if isLoading {
                    self.hideShareButton()
                    self.disableBackButton()
                    self.activityIndicator.startAnimating()
                } else {
                    self.showShareButton()
                    self.enableBackButton()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    private func fetchImage() {
        guard let image = asset.getImageFromAsset(targetSize: idealPhotoResolution) else { return }

        if shouldCropImage {
            let croppedImage = image.crop(with: idealPhotoAspectRatio)
            postImage = croppedImage
            smallPhotoImageView.image = croppedImage
            largePhotoImageView.image = croppedImage
        } else {
            postImage = image
            smallPhotoImageView.image = image
            largePhotoImageView.image = image
        }
    }

    func shareButtonTapped() {
        view.endEditing(true)

        guard let postImage = postImage,
              let imageData = postImage.jpegData(compressionQuality: 1),
              let caption = captionTextView.text else { return }

        viewModel.createPost(withImage: imageData, aspectRatio: idealPhotoAspectRatio, caption: caption)
    }

    @objc private func showPreviewPhoto() {
        captionTextView.resignFirstResponder()
        view.addSubview(previewPhotoView)
        largePhotoImageView.frame = smallPhotoImageView.frame
        smallPhotoImageView.alpha = 0

        let width = view.bounds.width
        let height = width / idealPhotoAspectRatio
        let largePhotoFrame = CGRect(x: 0, y: (view.bounds.height - height) / 2, width: width, height: height)

        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.largePhotoImageView.frame = largePhotoFrame
            self.previewPhotoView.backgroundColor = .systemBackground.withAlphaComponent(0.9)
        }
    }

    @objc private func removePreviewPhoto() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut) {
            self.largePhotoImageView.frame = self.smallPhotoImageView.frame
            self.previewPhotoView.backgroundColor = .systemBackground.withAlphaComponent(0)
        } completion: { _ in
            self.smallPhotoImageView.alpha = 1
            self.previewPhotoView.removeFromSuperview()
        }
    }

    // MARK: - Helper

    private func hideShareButton() {
        navBar.hideRightBarButton(at: 0)
    }

    private func showShareButton() {
        navBar.showRightBarButton(at: 0)
    }

    private func disableBackButton() {
        navBar.disableLeftBarButton(at: 0)
    }

    private func enableBackButton() {
        navBar.enableLefttBarButton(at: 0)
    }
}

// MARK: - UITextViewDelegate

extension NewPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentHeight = textView.contentSize.height
        let maxHeight: CGFloat = 72
        let minHeight: CGFloat = 30
        captionTextViewHeightConstraint.constant = min(maxHeight, max(currentHeight, minHeight))
        view.layoutIfNeeded()
    }
}
