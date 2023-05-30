//
//  UserProfileButton2.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 04/05/2023.
//

import UIKit

class ActionProfileButton: UIButton {

    enum ActionProfileButtonType: String {
        case loading = "Loading"
        case follow = "Follow"
        case following = "Following"
        case message = "Message"
        case edit = "Edit profile"
        case share = "Share profile"
    }

    var actionType: ActionProfileButtonType = .loading

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setActionType(_ type: ActionProfileButtonType) {
        self.actionType = type
        configure()
    }

    private func configure() {
        backgroundColor = .systemGray3
        layer.cornerRadius = 6
        setTitle(actionType.rawValue, for: .normal)
        setTitleColor(UIColor.label, for: .normal)

        switch actionType {
            case .follow:
                backgroundColor = .link
                setTitleColor(UIColor.white, for: .normal)
            case .loading, .following, .message, .edit, .share:
                break
        }
    }
}
