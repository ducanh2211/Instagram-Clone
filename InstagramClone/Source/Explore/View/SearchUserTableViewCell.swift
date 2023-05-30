//
//  SearchUserTableViewCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 25/05/2023.
//

import UIKit

class SearchUserTableViewCell: UITableViewCell {

    static var identifier: String { String(describing: self) }

    // MARK: - UI components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 44/2
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

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with user: User) {
        profileImageView.sd_setImage(with: URL(string: user.avatarUrl), placeholderImage: UIImage(named: "user"), context: nil)
        userNameLabel.text = user.userName
        fullNameLabel.text = user.fullName
    }

    // MARK: - Setup

    private func setup() {
        let labelStack = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 0
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(profileImageView)
        contentView.addSubview(labelStack)

        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 44),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            labelStack.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 6),
            labelStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            labelStack.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, constant: -8),
            labelStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
