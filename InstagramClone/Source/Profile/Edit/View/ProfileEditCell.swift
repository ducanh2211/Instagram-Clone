//
//  ProfileEditCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

class ProfileEditCell: UITableViewCell {

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let primaryInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    static var identifier: String { String(describing: self) }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with infoData: ProfileEditController.UserInfoData?) {
        guard let infoData = infoData else { return }
        descriptionLabel.text = infoData.type.description

        if infoData.data.isEmpty {
            primaryInfoLabel.text = infoData.type.description
            primaryInfoLabel.textColor = .systemGray3
        } else {
            primaryInfoLabel.text = infoData.data
            primaryInfoLabel.textColor = .label
        }
    }
    
    private func setup() {
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(primaryInfoLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            descriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 80),

            primaryInfoLabel.leftAnchor.constraint(equalTo: descriptionLabel.rightAnchor, constant: 10),
            primaryInfoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            primaryInfoLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
            primaryInfoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
        ])
    }
}
