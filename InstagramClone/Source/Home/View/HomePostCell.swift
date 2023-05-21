//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 17/05/2023.
//

import UIKit

class HomePostCell: UICollectionViewCell {
  
  static var identifier: String { String(describing: self) }
  
  // MARK: - UI components
  private lazy var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(named: "vtv24-logo")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 32/2
    return imageView
  }()
  
  private let userNameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "vtv24news"
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.numberOfLines = 1
    return label
  }()
  
  private lazy var moreButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
    button.setImage(UIImage(systemName: "ellipsis", withConfiguration: config), for: .normal)
    button.tintColor = .label
    button.setContentHuggingPriority(.required, for: .horizontal)
    return button
  }()
  
  private lazy var photoPostImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.image = UIImage(named: "heroImage")
    return imageView
  }()
  
//  private lazy var likeButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.translatesAutoresizingMaskIntoConstraints = false
//    let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
//    let weight = UIImage.SymbolConfiguration(weight: .medium)
//    let config = font.applying(weight)
//    button.setImage(UIImage(systemName: "heart", withConfiguration: config), for: .normal)
//    button.tintColor = .label
//    return button
//  }()
//
//  private lazy var commentButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.translatesAutoresizingMaskIntoConstraints = false
//    let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
//    let weight = UIImage.SymbolConfiguration(weight: .medium)
//    let config = font.applying(weight)
//    button.setImage(UIImage(systemName: "message", withConfiguration: config), for: .normal)
//    button.tintColor = .label
//    return button
//  }()
//
//  private lazy var shareButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.translatesAutoresizingMaskIntoConstraints = false
//    let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
//    let weight = UIImage.SymbolConfiguration(weight: .medium)
//    let config = font.applying(weight)
//    button.setImage(UIImage(systemName: "paperplane", withConfiguration: config), for: .normal)
//    button.tintColor = .label
//    return button
//  }()
//
//  private lazy var saveButton: UIButton = {
//    let button = UIButton(type: .system)
//    button.translatesAutoresizingMaskIntoConstraints = false
//    let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
//    let weight = UIImage.SymbolConfiguration(weight: .medium)
//    let config = font.applying(weight)
//    button.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
//    button.tintColor = .label
//    return button
//  }()
  
  private lazy var buttonActions: CustomNavigationBar = {
    let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
    let weight = UIImage.SymbolConfiguration(weight: .medium)
    let config = font.applying(weight)
    
    let likeImage = UIImage(systemName: "heart", withConfiguration: config)!
    let likeButton = AttributedButton(image: likeImage)
    
    let commentImage = UIImage(systemName: "message", withConfiguration: config)!
    let commentButton = AttributedButton(image: commentImage)
    
    let shareImage = UIImage(systemName: "paperplane", withConfiguration: config)!
    let shareButton = AttributedButton(image: shareImage)
    
    let saveButton = AttributedButton(image: UIImage(named: "save-icon")!,
                                      size: CGSize(width: 23, height: 22))
    
    let actionButtons = CustomNavigationBar(shouldShowSeparator: false,
                                            leftBarButtons: [likeButton, commentButton, shareButton],
                                            rightBarButtons: [saveButton])
    actionButtons.translatesAutoresizingMaskIntoConstraints = false
    return actionButtons
  }()
  
  private lazy var likeInfoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "472 likes"
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.numberOfLines = 1
    return label
  }()
  
  private var captionPostLable: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "vtv24news Khi tiếng còi kết thúc trận chung kết vang lên, HLV Mai Đức Chung đã để lại hình ảnh xúc động tại SEA Games 32, khi tay cầm chiếc loa và chạy đường pitch của sân và nói lớn rằng: \"Cảm ơn người hâm mộ. Cảm ơn tất cả mọi người đã đồng hành cùng ĐT nữ Việt Nam.\""
    label.font = .systemFont(ofSize: 13, weight: .regular)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  
  private let allCommentsLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "View all 10 comments"
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.numberOfLines = 1
    label.textColor = .systemGray
    return label
  }()
  
  private var timeLineLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "1 day ago"
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.numberOfLines = 1
    label.textColor = .systemGray
    return label
  }()
  
  // MARK: - Properties
  private var photoPostImageViewHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Setup
extension HomePostCell {
  private func setup() {
    
    // stack view
    let topStack = UIStackView(arrangedSubviews: [profileImageView, userNameLabel, moreButton])
    topStack.spacing = 10
    topStack.translatesAutoresizingMaskIntoConstraints = false
    
//    let buttonStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
//    buttonStack.spacing = 12
//    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    
    let bottomStack = UIStackView(arrangedSubviews: [likeInfoLabel,captionPostLable,
                                                     allCommentsLabel, timeLineLabel])
    bottomStack.axis = .vertical
    bottomStack.spacing = 4
    bottomStack.translatesAutoresizingMaskIntoConstraints = false
    
    // add subviews
    contentView.addSubview(topStack)
    contentView.addSubview(photoPostImageView)
//    contentView.addSubview(buttonStack)
//    contentView.addSubview(saveButton)
    contentView.addSubview(buttonActions)
    contentView.addSubview(bottomStack)
    
    // active contraints
    photoPostImageViewHeightConstraint = photoPostImageView.heightAnchor.constraint(equalTo: photoPostImageView.widthAnchor)
    
    NSLayoutConstraint.activate([
      profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
      topStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
      topStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      topStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
      topStack.heightAnchor.constraint(equalToConstant: 32),
      
      photoPostImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      photoPostImageView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 11),
      photoPostImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      photoPostImageViewHeightConstraint,
      
//      buttonStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
//      buttonStack.topAnchor.constraint(equalTo: photoPostImageView.bottomAnchor, constant: 13),
//      buttonStack.heightAnchor.constraint(equalToConstant: 22),
//
//      saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
//      saveButton.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
//      saveButton.heightAnchor.constraint(equalToConstant: 22),
      
      buttonActions.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 3),
      buttonActions.topAnchor.constraint(equalTo: photoPostImageView.bottomAnchor, constant: 13),
      buttonActions.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -3),
      buttonActions.heightAnchor.constraint(equalToConstant: 22),
      
      bottomStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
//      bottomStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 12),
      bottomStack.topAnchor.constraint(equalTo: buttonActions.bottomAnchor, constant: 12),
      bottomStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
      bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
