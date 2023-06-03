//
//  CommentInputView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 02/06/2023.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
    func didTapSendButton(with text: String)
}

class CommentInputView: UIView, UITextViewDelegate {

    // MARK: - UI components

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 42/2
        imageView.backgroundColor = .systemPink
        return imageView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.borderWidth = 0.35
        view.layer.cornerRadius = 42/2
        view.clipsToBounds = true
        return view
    }()

    private let inputTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeHolderText = "Add a comment..."
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.4
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Properties

    weak var delegate: CommentInputViewDelegate?
    let initialHeight: CGFloat = 62
    var profileImageString: String = "" {
        didSet {
            profileImageView.sd_setImage(with: URL(string: profileImageString), placeholderImage: UIImage(named: "user"), context: nil)
        }
    }
    private var inputTextViewHeightConstraint: NSLayoutConstraint!
    private let minHeight: CGFloat = 32
    private let maxHeight: CGFloat = 100

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        inputTextView.delegate = self
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    @objc private func didTapSendButton() {
        guard let text = inputTextView.text, !text.isEmpty else { return }
        delegate?.didTapSendButton(with: text)
        clearTextView()
    }

    private func clearTextView() {
        inputTextView.text = nil
        inputTextView.resignFirstResponder()
        inputTextView.textDidChange()
        textViewDidChange(inputTextView)
    }

    func textViewDidChange(_ textView: UITextView) {
        let height = textView.contentSize.height
        inputTextViewHeightConstraint.constant = min(maxHeight, max(minHeight, height))
        layoutIfNeeded()

        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            disableSendButton()
        } else {
            enableSendButton()
        }
    }

    private func enableSendButton() {
        sendButton.isEnabled = true
        sendButton.alpha = 1
    }

    private func disableSendButton() {
        sendButton.isEnabled = false
        sendButton.alpha = 0.4
    }

    // MARK: - Setup

    func setup() {
        addSubview(separatorView)
        addSubview(profileImageView)
        addSubview(containerView)
        containerView.addSubview(inputTextView)
        containerView.addSubview(sendButton)

        inputTextViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: minHeight)

        NSLayoutConstraint.activate([
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.25),

            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            profileImageView.widthAnchor.constraint(equalToConstant: 42),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            containerView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            containerView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),

            inputTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            inputTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            inputTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5),
            inputTextViewHeightConstraint,

            sendButton.leftAnchor.constraint(equalTo: inputTextView.rightAnchor),
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
}
