//
//  ProfileEditDetailController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

protocol ProfileEditDetailControllerDelegate: AnyObject {
    func userInfoDidChange(with newInfo: ProfileEditController.UserInfoData)
}

class ProfileEditDetailController: UIViewController, CustomizableNavigationBar {

    // MARK: UI components

    var navBar: CustomNavigationBar!

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .systemGray
        return label
    }()

    private var infoTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 17)
        return textField
    }()

    private let infoTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 17)
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        return textView
    }()

    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    // MARK: Properties

    weak var delegate: ProfileEditDetailControllerDelegate?
    private let infoType: ProfileEditController.UserInfoType
    private let user: User

    // MARK: Initialzer

    init(infoType: ProfileEditController.UserInfoType, user: User) {
        self.infoType = infoType
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("DEBUG: ProfileEditDetailController deinit")
        removeNotification()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        addNotification()
    }

    // MARK: Functions

    private func didTapDoneButton() {
        if infoType == .name {
            guard let newText = infoTextField.text, !newText.isEmpty, newText != user.fullName else { return }
            delegate?.userInfoDidChange(with: .init(type: .name, data: newText))
        }
        else if infoType == .userName {
            guard let newText = infoTextField.text, !newText.isEmpty, newText != user.userName else { return }
            delegate?.userInfoDidChange(with: .init(type: .userName, data: newText))
        }
        else if infoType == .bio {
            guard let newText = infoTextView.text, !newText.isEmpty, newText != user.bio else { return }
            delegate?.userInfoDidChange(with: .init(type: .bio, data: newText))
        }

        navigationController?.popViewController(animated: true)
    }

    private func didTapCancelButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func textFieldDidChange(_ notification: Notification) {
        guard let textField = notification.object as? UITextField,
              textField == infoTextField else {
            return
        }

        let shouldEnable: Bool
        if infoType == .name {
            shouldEnable = !textField.text!.isEmpty && textField.text != user.fullName
        } else {
            shouldEnable = !textField.text!.isEmpty && textField.text != user.userName
        }
        shouldEnable ? enableDoneButton() : disableDoneButton()
    }

    @objc private func textViewDidChange(_ notification: Notification) {
        guard let textView = notification.object as? UITextView,
              textView == infoTextView else {
            return
        }
        let shouldEnable: Bool = !textView.text.isEmpty && textView.text != user.bio
        shouldEnable ? enableDoneButton() : disableDoneButton()
    }

    // MARK: Helper

    private func configure() {
        descriptionLabel.text = infoType.description

        switch infoType {
            case .name:
                infoTextField.text = user.fullName
                infoTextView.isHidden = true
                infoTextView.becomeFirstResponder()
            case .userName:
                infoTextField.text = user.userName
                infoTextView.isHidden = true
                infoTextView.becomeFirstResponder()
            case .bio:
                infoTextView.text = user.bio
                infoTextField.isHidden = true
                infoTextField.becomeFirstResponder()
        }
    }

    private func enableDoneButton() {
        navBar.enableRightBarButton(at: 0)
    }

    private func disableDoneButton() {
        navBar.disableRightBarButton(at: 0)
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(textFieldDidChange(_:)),
            name: UITextField.textDidChangeNotification, object: infoTextField
        )

        NotificationCenter.default.addObserver(
            self, selector: #selector(textViewDidChange(_:)),
            name: UITextView.textDidChangeNotification, object: infoTextView
        )
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: infoTextField)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: infoTextView)
    }
}

// MARK: - Setup

extension ProfileEditDetailController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupConstraints()
    }

    private func setupNavBar() {
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
        let backButton = AttributedButton(image: image) { [weak self] in
            self?.didTapCancelButton()
        }

        let doneButton = AttributedButton(title: "Done") { [weak self] in
            self?.didTapDoneButton()
        }

        navBar = CustomNavigationBar(title: infoType.description,
                                     leftBarButtons: [backButton],
                                     rightBarButtons: [doneButton])

        navBar.disableRightBarButton(at: 0)
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        view.addSubview(descriptionLabel)
        view.addSubview(infoTextField)
        view.addSubview(infoTextView)
        view.addSubview(separatorView)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 6),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),

            infoTextField.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor),
            infoTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            infoTextField.rightAnchor.constraint(equalTo: descriptionLabel.rightAnchor),

            infoTextView.leftAnchor.constraint(equalTo: infoTextField.leftAnchor),
            infoTextView.topAnchor.constraint(equalTo: infoTextField.topAnchor),
            infoTextView.rightAnchor.constraint(equalTo: infoTextField.rightAnchor),

            separatorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            separatorView.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: 5),
            separatorView.rightAnchor.constraint(equalTo: view.rightAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.25)
        ])
    }
}
