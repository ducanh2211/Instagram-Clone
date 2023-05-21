//
//  CustomNavigationBar.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 19/05/2023.
//

import UIKit

protocol CustomizableNavigationBar: AnyObject {
  var navBar: CustomNavigationBar! { get }
}

// MARK: - AttributedButton
struct AttributedButton {
  var image: UIImage?
  var title: String?
  var font: UIFont?
  var color: UIColor
  var size: CGSize?
  var completion: (() -> Void)?
  
  init() {
    self.image = nil
    self.title = "Button"
    self.font = .systemFont(ofSize: 16)
    self.color = .link
    self.size = nil
    self.completion = nil
  }
  
  init(image: UIImage,
       color: UIColor = .label,
       size: CGSize? = nil,
       completion: (() -> Void)? = nil) {
    
    self.image = image
    self.color = color
    self.size = size
    self.completion = completion
  }
  
  init(title: String,
       font: UIFont = .systemFont(ofSize: 16, weight: .semibold),
       color: UIColor = .link,
       completion: (() -> Void)? = nil) {
    
    self.title = title
    self.font = font
    self.color = color
    self.completion = completion
  }
}

// MARK: - CustomNavigationBar
class CustomNavigationBar: UIView {
  
  // MARK: - Properties
  let title: String?
  let shouldShowSeparator: Bool
  let leftBarButtons: [AttributedButton]?
  let rightBarButtons: [AttributedButton]?
  
  // MARK: - UI components
  private var titleLabel: UILabel!
  private var leftBarButtonItems: [UIButton]!
  private var rightBarButtonItems: [UIButton]!
  private var separatorView: UIView!
  
  // MARK: - Initializer
  deinit {
    print("DEBUG: navigation bar deinit")
  }
  init(title: String? = "",
       shouldShowSeparator: Bool = true,
       leftBarButtons: [AttributedButton]? = nil,
       rightBarButtons: [AttributedButton]? = nil) {
    
    self.title = title
    self.shouldShowSeparator = shouldShowSeparator
    self.leftBarButtons = leftBarButtons
    self.rightBarButtons = rightBarButtons
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Functions
  @objc private func didTapleftButton(_ sender: UIButton) {
    for (index, button) in leftBarButtonItems.enumerated() {
      if button == sender {
        guard let completion = leftBarButtons?[index].completion else { return }
        completion()
      }
    }
  }
  
  @objc private func didTapRightButton(_ sender: UIButton) {
    for (index, button) in rightBarButtonItems.enumerated() {
      if button == sender {
        guard let completion = rightBarButtons?[index].completion else { return }
        completion()
      }
    }
  }
  
  // MARK: - Setup
  private func setupView() {
    backgroundColor = .systemBackground
    setupTitleLabel()
    setupLeftBarButtonItems()
    setupRightBarButtonItems()
    setupSeparatorView()
  }
  
  private func setupTitleLabel() {
    // config
    titleLabel = UILabel()
    titleLabel.text = self.title
    titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    titleLabel.numberOfLines = 1
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // layout
    addSubview(titleLabel)
    NSLayoutConstraint.activate([
      titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func setupLeftBarButtonItems() {
    guard let leftBarButtons = leftBarButtons else { return }
    
    // config
    for (index, custom) in leftBarButtons.enumerated() {
      let button = UIButton(type: .system)
      button.tag = index
      button.imageView?.contentMode = .scaleAspectFit
      button.addTarget(self, action: #selector(didTapleftButton(_:)), for: .touchUpInside)
      button.tintColor = custom.color
      button.titleLabel?.font = custom.font
      button.titleLabel?.numberOfLines = 1
      button.setTitleColor(custom.color, for: .normal)
      button.setTitle(custom.title, for: .normal)
      button.setImage(custom.image, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      
      if leftBarButtonItems == nil {
        leftBarButtonItems = [button]
      } else {
        leftBarButtonItems.append(button)
      }
      
      if let size = custom.size {
        button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
      }
    }
    
    // layout
    let stack = UIStackView(arrangedSubviews: leftBarButtonItems)
    stack.spacing = 8
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stack)
    
    NSLayoutConstraint.activate([
      stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor),
      stack.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor)
    ])
  }
  
  private func setupRightBarButtonItems() {
    guard let rightBarButtons = rightBarButtons else { return }
    
    // config
    for (index, custom) in rightBarButtons.enumerated() {
      let button = UIButton(type: .system)
      button.tag = index
      button.imageView?.contentMode = .scaleAspectFit
      button.addTarget(self, action: #selector(didTapRightButton(_:)), for: .touchUpInside)
      button.tintColor = custom.color
      button.titleLabel?.font = custom.font
      button.titleLabel?.numberOfLines = 1
      button.setTitleColor(custom.color, for: .normal)
      button.setTitle(custom.title, for: .normal)
      button.setImage(custom.image, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      
      if rightBarButtonItems == nil {
        rightBarButtonItems = [button]
      } else {
        rightBarButtonItems.append(button)
      }
      
      if let size = custom.size {
        button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
      }
    }
    
    // layout
    let stack = UIStackView(arrangedSubviews: rightBarButtonItems.reversed())
    stack.spacing = 8
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stack)
    NSLayoutConstraint.activate([
      stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
      stack.centerYAnchor.constraint(equalTo: centerYAnchor),
      stack.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor)
    ])
  }
  
  private func setupSeparatorView() {
    // config
    separatorView = UIView()
    separatorView.backgroundColor = .lightGray
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.isHidden = !shouldShowSeparator
    
    // layout
    addSubview(separatorView)
    NSLayoutConstraint.activate([
      separatorView.leftAnchor.constraint(equalTo: leftAnchor),
      separatorView.rightAnchor.constraint(equalTo: rightAnchor),
      separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 0.5)
    ])
  }
  
}
