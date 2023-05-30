//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 28/05/2023.
//

import UIKit

protocol CommentInputAccessoryDelegate: AnyObject {
    func didTapSendButton(with text: String)
}

class CommentInputAccessoryView: UIView, UITextViewDelegate {

    // MARK: - Properties

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
        imageView.layer.cornerRadius = 40/2
        imageView.backgroundColor = .systemPink
        return imageView
    }()

    let inputTextView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 40/2
        textView.showsVerticalScrollIndicator = false
        textView.placeHolderLeftConstraintConstant = 18
        textView.placeHolderTopConstraintConstant = 10
        textView.placeHolderText = "Add a comment..."
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.4
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(UIColor.link, for: .normal)
        button.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer

    var initialHeight: CGFloat = 60
    weak var delegate: CommentInputAccessoryDelegate?
    var profileImageString: String = "" {
        didSet {
            profileImageView.sd_setImage(with: URL(string: profileImageString), placeholderImage: UIImage(named: "user"), context: nil)
        }
    }

    private var inputTextViewHeightConstraint: NSLayoutConstraint!
    private let minHeight: CGFloat = 40
    private let maxHeight: CGFloat = 100

    override var intrinsicContentSize: CGSize {
        return .zero
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
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
        inputTextView.textDidChange()
        textViewDidChange(inputTextView)
//        disableSendButton()
    }

    func textViewDidChange(_ textView: UITextView) {
        let currentHeight = textView.contentSize.height
        inputTextViewHeightConstraint.constant = min(maxHeight, max(currentHeight, minHeight))
        layoutIfNeeded()

        if textView.text.isEmpty {
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

    private func setup() {
        backgroundColor = .systemGroupedBackground
        inputTextView.delegate = self
        setupConstraints()
    }

    private func setupConstraints() {
        addSubview(separatorView)
        addSubview(profileImageView)
        addSubview(inputTextView)
        addSubview(sendButton)

        inputTextViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: minHeight)

        NSLayoutConstraint.activate([
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.25),

            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            profileImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -(initialHeight - minHeight)/2),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            inputTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            inputTextView.topAnchor.constraint(equalTo: topAnchor, constant: (initialHeight - minHeight)/2),
            inputTextView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            inputTextViewHeightConstraint,

            sendButton.leftAnchor.constraint(equalTo: inputTextView.rightAnchor, constant: 15),
            sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            sendButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        ])
    }
}
