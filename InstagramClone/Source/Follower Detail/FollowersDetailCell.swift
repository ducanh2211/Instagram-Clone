//
//  FollowersDetailCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 01/06/2023.
//

import UIKit

class FollowersDetailCell: UITableViewCell {

    static var identifier: String { String(describing: self) }

    // MARK: - UI components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 52/2
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textColor = UIColor.lightGray
        return label
    }()

    private lazy var followButton: ActionProfileButton = {
        let button = ActionProfileButton()
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer

    var user: User? {
        didSet { configure() }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        followButton.isHidden = false
    }

    // MARK: - Functions

    @objc private func didTapFollowButton() {
        guard let user = user else { return }

        if followButton.actionType == .follow {
            UserManager.shared.followUser(otherUid: user.uid) { _ in }
            self.followButton.setActionType(.following)
        }
        else if followButton.actionType == .following {
            UserManager.shared.unfollowUser(otherUid: user.uid) { _ in }
            self.followButton.setActionType(.follow)
        }
    }

    private func configure() {
        guard let user = user else { return }
        profileImageView.sd_setImage(with: URL(string: user.avatarUrl), placeholderImage: UIImage(named: "user"), context: nil)
        userNameLabel.text = user.userName
        fullNameLabel.text = user.fullName
        configureFollowButton()
    }

    private func configureFollowButton() {
        guard let user = user else { return }

        let isLoggedInUser = UserManager.shared.checkIfLoggedInUser(uid: user.uid)
        if isLoggedInUser {
            followButton.isHidden = true
            return
        }

        UserManager.shared.checkFollowState(withOtherUser: user.uid) { [weak self] isFollow in
            DispatchQueue.main.async {
                if isFollow {
                    self?.followButton.setActionType(.following)
                } else {
                    self?.followButton.setActionType(.follow)
                }
            }
        }
    }
}

// MARK: - Setup

extension FollowersDetailCell {
    private func setup() {
        let stack = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 4

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(profileImageView)
        contentView.addSubview(stack)
        contentView.addSubview(followButton)

        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            profileImageView.widthAnchor.constraint(equalToConstant: 52),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            stack.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
            stack.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),

            followButton.leftAnchor.constraint(equalTo: stack.rightAnchor, constant: 15),
            followButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            followButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 100),
            followButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
