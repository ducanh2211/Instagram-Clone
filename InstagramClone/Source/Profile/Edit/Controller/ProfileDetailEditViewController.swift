//
//  ProfileDetailEditViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

class ProfileDetailEditViewController: UIViewController, CustomizableNavigationBar {
  
  var navBar: CustomNavigationBar!
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: 17, weight: .medium)
    label.textColor = .systemGray
    return label
  }()
  
  private let infoTextField: UITextField = {
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
    view.backgroundColor = .lightGray
    return view
  }()
  
  // MARK: - Initialzer
  private let userInfo: ProfileEditViewController.UserInfoData
  
  init(userInfo: ProfileEditViewController.UserInfoData) {
    self.userInfo = userInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    configure()
  }
  
  // MARK: - Functions
  private func configure() {
    descriptionLabel.text = userInfo.type.description
    
    switch userInfo.type {
      case .bio:
        infoTextField.isHidden = true
        infoTextView.text = userInfo.data
        infoTextField.becomeFirstResponder()
      default:
        infoTextField.text = userInfo.data
        infoTextView.isHidden = true
        infoTextView.becomeFirstResponder()
    }
  }
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    setupNavBar()
    setupConstraints()
  }
  
  private func setupNavBar() {
    let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
    let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
    let backButton = AttributedButton(image: image) { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    
    let doneButton = AttributedButton(title: "Done") { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    
    navBar = CustomNavigationBar(title: userInfo.type.description,
                                 leftBarButtons: [backButton],
                                 rightBarButtons: [doneButton])
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
