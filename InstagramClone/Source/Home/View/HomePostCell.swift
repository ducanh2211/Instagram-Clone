//
//  HomePostCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 17/05/2023.
//

import UIKit

protocol HomePostCellDelegate: AnyObject {
    func didTapProfileImageView(_ cell: HomePostCell)
    func didTapUserNameLabel(_ cell: HomePostCell)
    func didTapLikeButton(_ cell: HomePostCell)
    func didTapCommentButton(_ cell: HomePostCell)
    func didTapLikeCounterLabel(_ cell: HomePostCell)
    func didTapCommentCounterLabel(_ cell: HomePostCell)
    func didTapCaptionLabel(_ cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {

    static var identifier: String { String(describing: self) }

    // MARK: - UI components
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32/2
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImageView))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapUserNameLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var moreButton: UIButton = {
        let button = createButton(imageName: "ellipsis")
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        return button
    }()

    private let postPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var likeButton: UIButton = {
        let button = createButton(imageName: "heart")
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()

    private lazy var commentButton: UIButton = {
        let button = createButton(imageName: "message")
        button.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        return button
    }()

    private lazy var shareButton: UIButton = {
        let button = createButton(imageName: "paperplane")
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = createButton(imageName: "bookmark")
        return button
    }()

    private lazy var likeCounterLabel: UILabel = {
        let label = createLalbel(contentHugging: .defaultLow + 1, contentCompression: .defaultHigh + 1)
        label.font = .systemFont(ofSize: 13, weight: .bold)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLikeCounterLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var captionLabel: UILabel = {
        let label = createLalbel(contentHugging: .defaultHigh, contentCompression: .required - 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCaptionLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var commentCounterLabel: UILabel = {
        let label = createLalbel(contentHugging: .defaultLow, contentCompression: .defaultHigh)
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCommentCounterLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    private lazy var timeLineLabel: UILabel = {
        let label = createLalbel(contentHugging: .defaultLow - 1, contentCompression: .defaultHigh - 1)
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    // MARK: - Properties

    weak var delegate: HomePostCellDelegate?
    private var postPhotoImageViewHeightConstraint: NSLayoutConstraint!
    var viewModel: HomePostCellViewModel? {
        didSet {
            configure()
//            bindViewModel()
        }
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {
        guard let viewModel = viewModel else { return }

        viewModel.getNumberOfCommentsSuccess = { [weak self] in
            self?.commentCounterLabel.text = viewModel.commentsCounterText
        }
        viewModel.getNumberOfLikesSuccess = { [weak self] in
            guard let self = self else { return }
            self.configureLikeCounterLalbel()
        }
        viewModel.checkLikesStateSuccess = { [weak self] in
            guard let self = self else { return }
            self.configureLikeButton()
        }
    }

    private func configure() {
        guard let viewModel = viewModel else { return }
        profileImageView.sd_setImage(with: URL(string: viewModel.userAvatarUrl),
                                     placeholderImage: UIImage(named: "user"), context: nil)
        userNameLabel.text = viewModel.userName
        postPhotoImageView.sd_setImage(with: URL(string: viewModel.postImageUrl))
        captionLabel.attributedText = viewModel.captionAttributedText
        timeLineLabel.text = viewModel.timeLineText
        commentCounterLabel.text = viewModel.commentsCounterText
        configurePostPhotoHeight()
        configureLikeButton()
        configureLikeCounterLalbel()
    }

    private func configureLikeCounterLalbel() {
        guard let viewModel = viewModel else { return }
        likeCounterLabel.isHidden = viewModel.shouldHideCounterLabel
        likeCounterLabel.text = viewModel.likeCounterText
    }

    private func configureLikeButton() {
        guard let viewModel = viewModel else { return }
        let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
        let weight = UIImage.SymbolConfiguration(weight: .medium)
        let config = font.applying(weight)
        let image: UIImage? = viewModel.likedByCurrentUser ?
        UIImage(systemName: "heart.fill", withConfiguration: config) :
        UIImage(systemName: "heart", withConfiguration: config)
        let tintColor: UIColor = viewModel.likedByCurrentUser ? .red : .label

        likeButton.tintColor = tintColor
        likeButton.setImage(image, for: .normal)
    }

    private func configurePostPhotoHeight() {
        guard let viewModel = viewModel else { return }
        NSLayoutConstraint.deactivate([postPhotoImageViewHeightConstraint])
        postPhotoImageViewHeightConstraint = postPhotoImageView.heightAnchor.constraint(
            equalTo: postPhotoImageView.widthAnchor, multiplier: 1/viewModel.postImageAspectRatio)
        NSLayoutConstraint.activate([postPhotoImageViewHeightConstraint])
    }

    private func updateLikeButtonAndLabel() {
        configureLikeButton()
        configureLikeCounterLalbel()
        likeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.likeButton.transform = .identity
        }
    }

    // MARK: - Selectors

    @objc private func didTapProfileImageView() {
        delegate?.didTapProfileImageView(self)
    }

    @objc private func didTapUserNameLabel() {
        delegate?.didTapUserNameLabel(self)
    }

    @objc private func didTapLikeButton() {
        guard let viewModel = viewModel else { return }

        if viewModel.likedByCurrentUser {
            viewModel.unlikePost()
            viewModel.likesCount -= 1
            viewModel.likedByCurrentUser = false
            updateLikeButtonAndLabel()
        } else {
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
            viewModel.likePost()
            viewModel.likesCount += 1
            viewModel.likedByCurrentUser = true
            updateLikeButtonAndLabel()
        }
        delegate?.didTapLikeButton(self)
    }

    @objc private func didTapCommentButton() {
        delegate?.didTapCommentButton(self)
    }

    @objc private func didTapLikeCounterLabel() {
        delegate?.didTapLikeCounterLabel(self)
    }

    @objc private func didTapCommentCounterLabel() {
        delegate?.didTapCommentCounterLabel(self)
    }

    @objc private func didTapCaptionLabel() {
        delegate?.didTapCaptionLabel(self)
    }

    // MARK: - Helper

    private func createButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13))
        let weight = UIImage.SymbolConfiguration(weight: .medium)
        let config = font.applying(weight)
        button.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        button.tintColor = .label
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }

    private func createLalbel(contentHugging: UILayoutPriority, contentCompression: UILayoutPriority) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.setContentHuggingPriority(contentHugging, for: .vertical)
        label.setContentCompressionResistancePriority(contentCompression, for: .vertical)
        return label
    }
}

// MARK: - Setup
extension HomePostCell {
    private func setup() {
        // stack view
        let topStack = UIStackView(arrangedSubviews: [profileImageView, userNameLabel, moreButton])
        topStack.spacing = 10
        topStack.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        buttonStack.spacing = 12
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        let bottomStack = UIStackView(arrangedSubviews: [likeCounterLabel, captionLabel, commentCounterLabel, timeLineLabel])
        bottomStack.axis = .vertical
        bottomStack.spacing = 6
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        // add subviews
        contentView.addSubview(topStack)
        contentView.addSubview(postPhotoImageView)
        contentView.addSubview(buttonStack)
        contentView.addSubview(saveButton)
        contentView.addSubview(bottomStack)

        // active contraints
        postPhotoImageViewHeightConstraint = postPhotoImageView.heightAnchor.constraint(equalTo: postPhotoImageView.widthAnchor)
        let bottomStackBottomConstraint = bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomStackBottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 32),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            topStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            topStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            topStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            topStack.heightAnchor.constraint(equalToConstant: 32),

            postPhotoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            postPhotoImageView.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 11),
            postPhotoImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            postPhotoImageViewHeightConstraint,

            buttonStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            buttonStack.topAnchor.constraint(equalTo: postPhotoImageView.bottomAnchor, constant: 13),
            buttonStack.heightAnchor.constraint(equalToConstant: 22),
            likeButton.widthAnchor.constraint(equalToConstant: 25),
            commentButton.widthAnchor.constraint(equalToConstant: 23),
            shareButton.widthAnchor.constraint(equalToConstant: 25),
            
            saveButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            saveButton.centerYAnchor.constraint(equalTo: buttonStack.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 23),
            saveButton.heightAnchor.constraint(equalToConstant: 22),

            bottomStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            bottomStack.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 10),
            bottomStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            bottomStackBottomConstraint
        ])
    }
}
