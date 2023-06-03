//
//  CommentHeader.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 28/05/2023.
//

import UIKit

class CommentHeader: UICollectionReusableView {

    static var identifier: String { String(describing: self) }

    // MARK: - UI components

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30/2
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow + 1, for: .horizontal)
        return label
    }()

    private let timeLineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 1
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    // MARK: - Initializer

    var post: Post? {
        didSet { configure() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        guard let post = post else { return }
        profileImageView.sd_setImage(with: URL(string: post.user.avatarUrl), placeholderImage: UIImage(named: "user"), context: nil)
        userNameLabel.text = post.user.userName
        captionLabel.text = post.caption
        configureTimeLineLalbel()
    }

    private func configureTimeLineLalbel() {
        guard let post = post else { return }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.weekOfMonth, .day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        guard let duration = formatter.string(from: post.creationDate, to: Date()) else { return }
        timeLineLabel.text = duration
    }

    // MARK: - Setup

    private func setup() {
        let horizontalStack = UIStackView(arrangedSubviews: [userNameLabel, timeLineLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.spacing = 4

        let veritcalStack = UIStackView(arrangedSubviews: [horizontalStack, captionLabel])
        veritcalStack.axis = .vertical
        veritcalStack.distribution = .fill
        veritcalStack.spacing = 4

        let finalStack = UIStackView(arrangedSubviews: [profileImageView, veritcalStack])
        finalStack.axis = .horizontal
        finalStack.distribution = .fill
        finalStack.alignment = .top
        finalStack.spacing = 8
        finalStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(finalStack)
        addSubview(separatorView)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 30),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            finalStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            finalStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            finalStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            finalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
