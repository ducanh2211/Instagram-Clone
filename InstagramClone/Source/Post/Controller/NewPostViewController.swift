//
//  NewPostViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 23/04/2023.
//

import UIKit
import Photos

class NewPostViewController: UIViewController, CustomizableNavigationBar {
  
  // MARK: - UI components
  var navBar: CustomNavigationBar!
  
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
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(smallPhotoTapped))
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
    let view = UIView(frame: self.view.frame)
    view.addSubview(largePhotoImageView)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removePreviewPhoto))
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  private let largePhotoImageView: UIImageView = {
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
  
  private var shouldCropImage: Bool {
    originAspectRatio < PhotoConstants.Post.portraitAspectRatio || originAspectRatio > PhotoConstants.Post.landscapeAspectRatio
  }
  
  private lazy var idealPhotoAspectRatio: CGFloat = {
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
  
  private lazy var initialLargePhotoFrame: CGRect = {
    CGRect(x: stackView.frame.origin.x,
           y: stackView.frame.origin.y,
           width: smallPhotoImageView.frame.width,
           height: smallPhotoImageView.frame.height)
  }()
  
  private lazy var expandLargePhotoFrame: CGRect = {
    let width = view.bounds.width
    let height: CGFloat = width / idealPhotoAspectRatio
    return CGRect(x: 0, y: (view.bounds.height - height) / 2,
                  width: width, height: height)
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
    print("NewPostViewController deinit")
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
        self?.dismiss(animated: true)
      }
    }
    
    viewModel.createPostFailure = { [weak self] error in
      DispatchQueue.main.async {
        self?.dismiss(animated: true)
      }
    }
    
    viewModel.loadingIndicator = { [weak self] in
      guard let self = self else { return }
      let isLoading = self.viewModel.isLoading
      isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
    }
  }
  
  private func fetchImage() {
    guard let image = asset.getImageFromAsset(targetSize: idealPhotoResolution) else { return }
    
    if shouldCropImage {
      let croppedImage = image.crop(with: idealPhotoAspectRatio)
      postImage = croppedImage
      smallPhotoImageView.image = croppedImage
      largePhotoImageView.image = croppedImage
    }
    else {
      postImage = image 
      smallPhotoImageView.image = image
      largePhotoImageView.image = image
    }
    
  }
  
  @objc private func shareButtonTapped() {
    view.endEditing(true)
    
    guard let postImage = postImage,
          let imageData = postImage.jpegData(compressionQuality: 1),
          let caption = captionTextView.text else { return }
    
    viewModel.createPost(withImage: imageData, aspectRatio: idealPhotoAspectRatio, caption: caption)
  }
  
  @objc private func smallPhotoTapped() {
    view.addSubview(previewPhotoView)
    largePhotoImageView.frame = initialLargePhotoFrame
    showPreviewPhoto()
  }
  
  @objc private func removePreviewPhoto() {
    hidePreviewPhoto()
  }
  
  private func showPreviewPhoto() {
    self.smallPhotoImageView.alpha = 0
    UIView.animate(withDuration: 0.75, delay: 0,
                   usingSpringWithDamping: 0.8,
                   initialSpringVelocity: 1,
                   options: .curveEaseInOut, animations: {
      self.largePhotoImageView.frame = self.expandLargePhotoFrame
      self.previewPhotoView.backgroundColor = .systemBackground.withAlphaComponent(0.9)
    })
  }
  
  private func hidePreviewPhoto() {
    UIView.animate(withDuration: 0.75, delay: 0,
                   usingSpringWithDamping: 0.75,
                   initialSpringVelocity: 1,
                   options: .curveEaseInOut, animations: {
      self.largePhotoImageView.frame = self.initialLargePhotoFrame
      self.previewPhotoView.backgroundColor = .systemBackground.withAlphaComponent(0)
    }, completion: { _ in
      self.smallPhotoImageView.alpha = 1
      self.previewPhotoView.removeFromSuperview()
    })
  }
  
}

// MARK: - Setup
extension NewPostViewController {
  private func setupView() {
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .systemBackground
    setupNavBar()
    setupConstraints()
  }
  
  private func setupNavBar() {
    let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
    let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
    let backButton = AttributedButton(image: image) { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    
    let shareButton = AttributedButton(title: "Share") { [weak self] in
      self?.shareButtonTapped()
    }
    
    navBar = CustomNavigationBar(title: "New post",
                                 shouldShowSeparator: false,
                                 leftBarButtons: [backButton],
                                 rightBarButtons: [shareButton])
  }
  
  private func setupConstraints() {
    navBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(navBar)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
      navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
      navBar.heightAnchor.constraint(equalToConstant: 44),
      
      smallPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
      smallPhotoImageView.widthAnchor.constraint(equalTo: smallPhotoImageView.heightAnchor,
                                                 multiplier: idealPhotoAspectRatio),
      
      captionTextView.heightAnchor.constraint(equalTo: smallPhotoImageView.heightAnchor),
      
      stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
      stackView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
      stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
      stackView.heightAnchor.constraint(equalToConstant: 140)
    ])
  }
}
