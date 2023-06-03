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
    func didTapFollowOrEditButton()
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
        button.isHidden = true
        button.setTitle("See more", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(seeMoreButtonTapped), for: .touchUpInside)
        return button
    }()

    var storyCollectionView: UICollectionView!

    // MARK: - Properties

    weak var delegate: ProfileHeaderControllerDelegate?
    var otherUser: User?
    var currentUser: User {
        didSet { reloadData() }
    }
    private var isLoggedInUser: Bool {
        return otherUser == nil
    }

    // MARK: - Intializer

    init(currentUser: User, otherUser: User?) {
        self.currentUser = currentUser
        self.otherUser = otherUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .reloadUserProfileFeed, object: nil)
        print("DEBUG: ProfileHeaderController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadUserProfileFeed, object: nil)
    }

    // MARK: - Functions

    @objc private func reloadData() {
        let user = isLoggedInUser ? currentUser : otherUser!
        profileImageView.sd_setImage(with: URL(string: user.avatarUrl), placeholderImage: UIImage(named: "user"), context: nil)
        fullNameLabel.text = user.fullName
        bioLabel.text = user.bio
        reloadUserStat()
        reloadActionButton()
        configureSeeMoreButton()
    }

    private func reloadUserStat() {
        let user = isLoggedInUser ? currentUser : otherUser!

        UserManager.shared.numberOfPost(forUser: user.uid) { [weak self] count in
            DispatchQueue.main.async {
                self?.postsLabel.setValue(count)
            }
        }
        UserManager.shared.numberOfFollowing(forUser: user.uid) { [weak self] count in
            DispatchQueue.main.async {
                self?.followingLabel.setValue(count)
            }
        }
        UserManager.shared.numberOfFollowers(forUser: user.uid) { [weak self] count in
            DispatchQueue.main.async {
                self?.followerslabel.setValue(count)
            }
        }
    }

    private func reloadActionButton() {
        if isLoggedInUser {
            followOrEditButton.setActionType(.edit)
            messageOrShareButton.setActionType(.share)

        } else {
            messageOrShareButton.setActionType(.message)

            UserManager.shared.checkFollowState(withOtherUser: otherUser!.uid) { [weak self] isFollow in
                DispatchQueue.main.async {
                    if isFollow {
                        self?.followOrEditButton.setActionType(.following)
                    } else {
                        self?.followOrEditButton.setActionType(.follow)
                    }
                }
            }
        }
    }

    @objc private func didTapFollowOrEditButton() {
        if isLoggedInUser {
            delegate?.didTapFollowOrEditButton()
        } else {
            if followOrEditButton.actionType == .follow {
                UserManager.shared.followUser(otherUid: otherUser!.uid) { [weak self] _ in
                    self?.reloadUserStat()
                }
                self.followOrEditButton.setActionType(.following)
            }
            else if followOrEditButton.actionType == .following {
                UserManager.shared.unfollowUser(otherUid: otherUser!.uid) { [weak self] _ in
                    self?.reloadUserStat()
                }
                self.followOrEditButton.setActionType(.follow)
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

    @objc private func seeMoreButtonTapped() {
        bioLabel.numberOfLines = 0
        seeMoreButton.isHidden = true
    }

    private func configureSeeMoreButton() {
        DispatchQueue.main.async {
            let isTruncated = self.bioLabel.isTextTruncated()
            self.seeMoreButton.isHidden = isTruncated ? false : true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileHeaderController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfileStoryCell.identifier, for: indexPath) as! ProfileStoryCell
        return cell
    }
}
