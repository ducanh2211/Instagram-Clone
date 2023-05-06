//
//  SignUpViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class SignUpViewController: UIViewController {
  
  private let viewModel = SignUpViewModel()
  
  // MARK: UI components
  private lazy var statusView: StatusView = {
    let view = StatusView()
    view.title = "Create account"
    view.backButtonTapped = { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
//  private let indicatorActivity: UIActivityIndicatorView = {
//    let spinner = UIActivityIndicatorView(style: .large)
//    spinner.translatesAutoresizingMaskIntoConstraints = false
//    return spinner
//  }()
  
  private lazy var emailTextField: UITextField = {
    let textField = createTextField(placeHolder: "Email", tag: 0)
    textField.keyboardType = .emailAddress
    return textField
  }()
  
  private lazy var fullNameTextField: UITextField = {
    let textField = createTextField(placeHolder: "Full Name", tag: 1)
    textField.autocapitalizationType = .words
    return textField
  }()
  
  private lazy var userNameTextField: UITextField = {
    let textField = createTextField(placeHolder: "Username", tag: 2)
    textField.autocapitalizationType = .words
    return textField
  }()
  
  private lazy var passwordTextField: UITextField = {
    let textField = createTextField(placeHolder: "Password", tag: 3)
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
  
  private lazy var signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign up", for: .normal)
    button.setTitleColor(UIColor.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    button.backgroundColor = .systemBlue
    button.alpha = 0.5
    button.isEnabled = false
    button.layer.cornerRadius = 5
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var alreadyHaveAccountButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Already have an account?", for: .normal)
    button.setTitleColor(UIColor.link, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(alreadyHaveAccountButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    hideKeyBoardWhenTapped()
    bindViewModel()
  }

  deinit {
    print("SignUpViewController deinit")
  }
  
//  override func viewDidLayoutSubviews() {
//    super.viewDidLayoutSubviews()
//    dropShadow()
//  }
  
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
        guard let tabBarController = UIApplication
          .shared.keyWindow?.rootViewController as? TabBarViewController else { return }
        tabBarController.validateUser()
        self.errorLabel.isHidden = true
        self.dismiss(animated: true)
      }
    }
  }
  
  @objc private func validateInput(_ textfield: UITextField) {
    let textFields = [emailTextField, fullNameTextField, userNameTextField, passwordTextField]
    let validTextFields = textFields.filter { !$0.text!.isEmpty }
    let isInputValid = validTextFields.count == textFields.count
    isInputValid ? enableSignUpButton() : disableSignUpButton()
  }
  
  @objc private func signUpButtonTapped() {
    guard let email = emailTextField.text,
          let password = passwordTextField.text,
          let fullName = fullNameTextField.text,
          let userName = userNameTextField.text else { return }
    
    viewModel.signUpUser(email: email, password: password, fullName: fullName, username: userName)
  }
  
  @objc private func alreadyHaveAccountButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - Helpers
  private func disableSignUpButton() {
    signUpButton.isEnabled = false
    signUpButton.alpha = 0.5
  }
  
  private func enableSignUpButton() {
    signUpButton.isEnabled = true
    signUpButton.alpha = 1
  }
}

// MARK: - UI Layout
extension SignUpViewController {
  private func setupView() {
    view.backgroundColor = .systemBackground
    ProgressHUD.colorHUD = .black
    ProgressHUD.colorAnimation = .white
    setupConstraints()
  }
  
  private func setupConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    
    let stackView = UIStackView(arrangedSubviews: [
      emailTextField, fullNameTextField,
      userNameTextField, passwordTextField,
      errorLabel, signUpButton
    ])
    stackView.axis = .vertical
    stackView.spacing = 15
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
//    view.addSubview(indicatorActivity)
    view.addSubview(statusView)
    view.addSubview(stackView)
    view.addSubview(alreadyHaveAccountButton)

    NSLayoutConstraint.activate([
//      indicatorActivity.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//      indicatorActivity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      statusView.leftAnchor.constraint(equalTo: view.leftAnchor),
      statusView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      statusView.rightAnchor.constraint(equalTo: view.rightAnchor),
      statusView.heightAnchor.constraint(equalToConstant: 44),
      
      emailTextField.heightAnchor.constraint(equalToConstant: 50),
      fullNameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
      userNameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
      passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
      signUpButton.heightAnchor.constraint(equalToConstant: 50),
      
      stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 15),
      stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 75),
      stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -15),
      
      alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
      alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      alreadyHaveAccountButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
      alreadyHaveAccountButton.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
  
  private func dropShadow() {
    emailTextField.dropShadow()
    fullNameTextField.dropShadow()
    userNameTextField.dropShadow()
    passwordTextField.dropShadow()
    signUpButton.dropShadow(color: .black, opacity: 0.5, radius: 5)
  }
  
  private func createTextField(placeHolder: String, tag: Int) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeHolder
    textField.attributedPlaceholder = NSMutableAttributedString()
      .appendAttributedString(placeHolder, font: .systemFont(ofSize: 16, weight: .semibold))
    textField.font = .systemFont(ofSize: 16)
    textField.returnKeyType = .continue
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.layer.cornerRadius = 5
    textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    textField.layer.borderWidth = 1.25
    textField.tag = tag
    textField.setPadding(left: 8, right: 8)
    textField.addTarget(self, action: #selector(validateInput(_:)), for: .editingChanged)
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }
}
