//
//  NewPostViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 23/04/2023.
//

import UIKit
import Photos

class NewPostViewController: UIViewController {
  
  // MARK: - UI components
  private lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [smallPhotoImageView, captionTextView])
    stack.axis = .horizontal
    stack.spacing = 12
    stack.alignment = .top
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private lazy var smallPhotoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped))
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
    return imageView
  }()
  
  private let captionTextView: PlaceholderTextView = {
    let textView = PlaceholderTextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  
  private lazy var previewPhotoView: UIView = {
    let view = UIView(frame: self.view.bounds)
    view.backgroundColor = .systemBackground.withAlphaComponent(0.8)
    view.addSubview(largePhotoImageView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removePreviewPhotoView))
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  private let largePhotoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  // MARK: - Properties
  private let viewModel = NewPostViewModel()
  private let asset: PHAsset
  private var postImage: UIImage?
  
  private let idealPhotoResolution = CGSize(width: 1080, height: 1080)
  
  private lazy var photoAspectRatio: CGFloat = {
    return CGFloat(asset.pixelWidth) / CGFloat(asset.pixelHeight)
  }()
  
  private lazy var initialLargePhotoFrame: CGRect = {
    CGRect(x: stackView.frame.origin.x,
           y: stackView.frame.origin.y,
           width: smallPhotoImageView.frame.width,
           height: smallPhotoImageView.frame.height)
  }()
  
  private lazy var expandLargePhotoFrame: CGRect = {
    let screenHeight = view.bounds.height
    let screenWidth = view.bounds.width
    let finalWidth = screenWidth
    let height: CGFloat = finalWidth / photoAspectRatio
    let finalHeight: CGFloat = (height > 500) ? 500 : height
    return CGRect(x: 0, y: (screenHeight - finalHeight) / 2,
                  width: finalWidth, height: finalHeight)
  }()
  
  // MARK: - Life cycle
  init(asset: PHAsset) {
    self.asset = asset
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("NewPostViewController deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
    fetchImage()
    setupView()
  }
  
  // MARK: - Functions
  private func bindViewModel() {
    viewModel.createPostSuccess = { [weak self] in
      print("DEBUG: create post success on main thread is: \(Thread.isMainThread)")
      DispatchQueue.main.async {
        self?.dismiss(animated: true)
      }
    }
    
    viewModel.createPostFailure = { [weak self] error in
      print("DEBUG: create post failure error: \(error) on main thread is: \(Thread.isMainThread)")
      DispatchQueue.main.async {
        self?.dismiss(animated: true)
      }
    }
  }
  
  private func fetchImage() {
    let smallImage = asset.getImageFromAsset(targetSize: smallPhotoImageView.bounds.size)
    let largeImage = asset.getImageFromAsset(targetSize: idealPhotoResolution)
    postImage = largeImage
    smallPhotoImageView.image = smallImage
    largePhotoImageView.image = largeImage
  }
  
  @objc private func rightBarButtonTapped() {
    guard let postImage = postImage,
          let imageData = postImage.jpegData(compressionQuality: 1),
          let caption = captionTextView.text else { return }
    
    viewModel.createPost(withImage: imageData, aspectRatio: photoAspectRatio, caption: caption)
  }
  
  @objc private func photoImageViewTapped() {
    view.addSubview(previewPhotoView)
    largePhotoImageView.frame = initialLargePhotoFrame
    showPreviewPhoto()
  }
  
  @objc private func removePreviewPhotoView() {
    hidePreviewPhoto()
  }
  
  private func showPreviewPhoto() {
    UIView.animate(withDuration: 0.35) {
      self.smallPhotoImageView.alpha = 0
      self.largePhotoImageView.frame = self.expandLargePhotoFrame
    }
  }
  
  private func hidePreviewPhoto() {
    UIView.animate(withDuration: 0.35) {
      self.largePhotoImageView.frame = self.initialLargePhotoFrame
    } completion: { _ in
      self.smallPhotoImageView.alpha = 1
      self.previewPhotoView.removeFromSuperview()
    }
  }
  
}

// MARK: - UI Layout
extension NewPostViewController {
  private func setupView() {
    self.title = "New post"
    view.backgroundColor = .systemBackground
    setupNavigationBar()
    setupConstraints()
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self,
                                                        action: #selector(rightBarButtonTapped))
    navigationItem.rightBarButtonItem?.tintColor = .systemBlue
  }
  
  private func setupConstraints() {
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      smallPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
      smallPhotoImageView.widthAnchor.constraint(equalTo: smallPhotoImageView.heightAnchor, multiplier: photoAspectRatio),
      
      captionTextView.heightAnchor.constraint(equalTo: smallPhotoImageView.heightAnchor),
      
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
      stackView.heightAnchor.constraint(equalToConstant: 140)
    ])
  }
}
