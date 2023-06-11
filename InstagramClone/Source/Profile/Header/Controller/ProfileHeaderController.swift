//
//  ProfileHeaderController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit
import SDWebImage
import FirebaseAuth

// MARK: - Protocol

protocol ProfileHeaderControllerDelegate: AnyObject {
    func didTapEditProfileButton()
    func didTapMessageOrShareButton()
    func didTapFollowersLabel()
    func didTapFollowingLabel()
}

class ProfileHeaderController: UIViewController {

    // MARK: - UI components

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 86/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let postsLabel = UserStatLabel(type: .posts, value: 0)

    lazy var followerslabel: UserStatLabel = {
        let label = UserStatLabel(type: .followers, value: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFollowersLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    lazy var followingLabel: UserStatLabel = {
        let label = UserStatLabel(type: .following, value: 0)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapFollowingLabel))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()

    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var followOrEditButton: ActionProfileButton = {
        let button = ActionProfileButton()
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapFollowOrEditButton), for: .touchUpInside)
        return button
    }()

    lazy var messageOrShareButton: ActionProfileButton = {
        let button = ActionProfileButton()
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapMessageOrShareButton), for: .touchUpInside)
        return button
    }()

    lazy var seeMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("See more", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        return button
    }()

    var storyCollectionView: UICollectionView!

    // MARK: - Properties

    weak var delegate: ProfileHeaderControllerDelegate?
    var viewModel: ProfileHeaderViewModel

    // MARK: - Intializer

    init(viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeNotification()
        print("DEBUG: ProfileHeaderController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadData()
        addNotification()
    }

    // MARK: - Functions

    @objc private func didUploadNewPost() {
        reloadUserStat()
    }

    @objc private func currentUserDidUpdateInfo(_ notification: Notification) {
        if let currentUser = notification.userInfo?["currentUser"] as? User {
            viewModel.user = currentUser
            reloadData()
        }
    }

    @objc private func seeMoreButtonTapped() {
        bioLabel.numberOfLines = 0
        seeMoreButton.isHidden = true
    }

    @objc private func reloadData() {
        let user = viewModel.user
        profileImageView.sd_setImage(with: URL(string: user.avatarUrl), placeholderImage: UIImage(named: "user"), context: nil)
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        reloadUserStat()
        reloadActionButton()
        configureSeeMoreButton()
    }

    private func reloadUserStat() {
        viewModel.getUserStatSuccess = { [weak self] in
            guard let self = self else { return }
            self.postsLabel.setValue(self.viewModel.numberOfPosts)
            self.followingLabel.setValue(self.viewModel.numberOfFollowing)
            self.followerslabel.setValue(self.viewModel.numberOfFollowers)
        }
        viewModel.getUserStat()
    }

    private func reloadActionButton() {
        if viewModel.isCurrentUser {
            followOrEditButton.setActionType(.edit)
            messageOrShareButton.setActionType(.share)
        } else {
            messageOrShareButton.setActionType(.message)
            viewModel.getFollowState()
            viewModel.getFollowingStateSuccess = { [weak self] in
                guard let self = self else { return }
                let type: ActionProfileButton.ActionProfileButtonType = self.viewModel.isFollowing ? .following : .follow
                self.followOrEditButton.setActionType(type)
            }
        }
    }

    private func configureSeeMoreButton() {
        DispatchQueue.main.async {
            let isTruncated = self.bioLabel.isTextTruncated()
            self.seeMoreButton.isHidden = isTruncated ? false : true
        }
    }

    @objc private func didTapFollowOrEditButton() {
        if viewModel.isCurrentUser {
            delegate?.didTapEditProfileButton()
        } else {
            if viewModel.isFollowing {
                viewModel.unfollowUser()
                followOrEditButton.setActionType(.follow)
            } else {
                viewModel.followUser()
                followOrEditButton.setActionType(.following)
            }
        }
    }

    @objc private func didTapMessageOrShareButton() {
        delegate?.didTapMessageOrShareButton()
    }

    @objc private func didTapFollowersLabel() {
        delegate?.didTapFollowersLabel()
    }

    @objc private func didTapFollowingLabel() {
        delegate?.didTapFollowingLabel()
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didUploadNewPost),
                                               name: .userDidUploadNewPost, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(currentUserDidUpdateInfo),
                                               name: .currentUserDidUpdateInfo, object: nil)
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .userDidUploadNewPost, object: nil)
        NotificationCenter.default.removeObserver(self, name: .currentUserDidUpdateInfo, object: nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileHeaderController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.storyPhotos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileStoryCell.identifier, for: indexPath) as! ProfileStoryCell
        cell.photoString = viewModel.storyPhotos[indexPath.item]
        return cell
    }
}
