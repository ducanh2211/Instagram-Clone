//
//  LogInViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class LogInViewController: UIViewController {

    // MARK: - UI components
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "instagram-logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var emailTextField: UITextField = {
        let textField = createTextField(placeHolder: "Email")
        textField.keyboardType = .emailAddress
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = createTextField(placeHolder: "Password")
        textField.returnKeyType = .done
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .red
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.alpha = 0.5
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create new account", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        return button
    }()

    private let viewModel: LoginViewModel

    // MARK: - Life cycle
    init(viewModel: LoginViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyBoardWhenTapped()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dropShadow()
    }

    deinit {
        print("LogInViewController deinit")
    }

    // MARK: - Functions
    
    private func bindViewModel() {
        viewModel.loadingIndicator = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let isLoading = self.viewModel.isLoading
                isLoading ? ProgressHUD.show() : ProgressHUD.dismiss()
            }
        }

        viewModel.failure = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.errorLabel.isHidden = false
                self.errorLabel.text = self.viewModel.errorMessage
            }
        }

        viewModel.success = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                tabBarController.viewModel.user = self.viewModel.user
                tabBarController.validateUser()
                tabBarController.selectedIndex = 0
                self.errorLabel.isHidden = true
                self.dismiss(animated: true)
            }
        }
    }

    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        viewModel.logInUser(email: email, password: password)
    }

    @objc private func createAccountButtonTapped() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func validateInput(_ textfield: UITextField) {
        let textFields = [emailTextField, passwordTextField]
        let validTextFields = textFields.filter { !$0.text!.isEmpty }
        let isInputValid = validTextFields.count == textFields.count
        isInputValid ? enableSignUpButton() : disableSignUpButton()
    }

    private func disableSignUpButton() {
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }

    private func enableSignUpButton() {
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }

}

// MARK: - Setup

extension LogInViewController {
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .white
        setupConstraints()
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let screenHeight = UIScreen.main.bounds.height

        let stackView = UIStackView(arrangedSubviews: [
            emailTextField, passwordTextField,
            errorLabel, loginButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(logoImageView)
        view.addSubview(stackView)
        view.addSubview(createAccountButton)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: screenHeight*0.1),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 15),
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: screenHeight*0.1),
            stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15),

            createAccountButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            createAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createAccountButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            createAccountButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    private func dropShadow() {
        emailTextField.dropShadow()
        passwordTextField.dropShadow()
        loginButton.dropShadow(color: .black, opacity: 0.5, radius: 5)
    }

    private func createTextField(placeHolder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.attributedPlaceholder = NSMutableAttributedString()
            .appendAttributedString(placeHolder, font: .systemFont(ofSize: 16, weight: .semibold))
        textField.font = .systemFont(ofSize: 16)
        textField.returnKeyType = .continue
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1.25
        textField.setPadding(left: 8, right: 8)
        textField.addTarget(self, action: #selector(validateInput(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
