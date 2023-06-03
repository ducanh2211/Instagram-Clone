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

class CustomNavigationBar: UIView {

    // MARK: - UI components

    var titleLabel: UILabel!
    var leftBarButtonItems: [UIButton]!
    var rightBarButtonItems: [UIButton]!
    var separatorView: UIView!

    // MARK: - Properties

    var title: String? {
        didSet { titleLabel.text = title }
    }
    let shouldShowSeparator: Bool
    let leftBarButtons: [AttributedButton]?
    let rightBarButtons: [AttributedButton]?

    // MARK: - Initializer

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

    deinit {
        print("DEBUG: CustomNavigationBar deinit")
    }

    // MARK: - Functions

    @objc private func didTapleftButton(_ sender: UIButton) {
        for (index, button) in leftBarButtonItems.enumerated() {
            if button == sender {
                guard let completion = leftBarButtons?[index].action else { return }
                completion()
            }
        }
    }

    @objc private func didTapRightButton(_ sender: UIButton) {
        for (index, button) in rightBarButtonItems.enumerated() {
            if button == sender {
                guard let completion = rightBarButtons?[index].action else { return }
                completion()
            }
        }
    }

    // MARK: - Helper

    func enableRightBarButton(at index: Int) {
        guard let rightBarButtons = rightBarButtons,
              rightBarButtons.count <= index + 1 else {
            return
        }

        let rightBarButton = rightBarButtons[index]
        let rightBarButtonItem = rightBarButtonItems[index]
        rightBarButtonItem.isEnabled = true
        rightBarButtonItem.setTitleColor(rightBarButton.color, for: .normal)
    }

    func enableLefttBarButton(at index: Int) {
        guard let leftBarButtons = leftBarButtons,
              leftBarButtons.count <= index + 1 else {
            return
        }

        let leftBarButton = leftBarButtons[index]
        let leftBarButtonItem = leftBarButtonItems[index]
        leftBarButtonItem.isEnabled = true
        leftBarButtonItem.setTitleColor(leftBarButton.color, for: .normal)
    }

    func disableRightBarButton(at index: Int) {
        guard let rightBarButtons = rightBarButtons,
              rightBarButtons.count <= index + 1 else {
            return
        }

        let rightBarButtonItem = rightBarButtonItems[index]
        rightBarButtonItem.isEnabled = false
        rightBarButtonItem.setTitleColor(UIColor.lightGray, for: .normal)
    }

    func disableLeftBarButton(at index: Int) {
        guard let leftBarButtons = leftBarButtons,
              leftBarButtons.count <= index + 1 else {
            return
        }

        let leftBarButtonItem = leftBarButtonItems[index]
        leftBarButtonItem.isEnabled = false
        leftBarButtonItem.setTitleColor(UIColor.lightGray, for: .normal)
    }

    func hideRightBarButton(at index: Int) {
        guard let rightBarButtons = rightBarButtons,
              rightBarButtons.count <= index + 1 else {
            return
        }
        rightBarButtonItems[index].isHidden = true
    }

    func hideLeftBarButton(at index: Int) {
        guard let leftBarButtons = leftBarButtons,
              leftBarButtons.count <= index + 1 else {
            return
        }
        leftBarButtonItems[index].isHidden = true
    }

    func showRightBarButton(at index: Int) {
        guard let rightBarButtons = rightBarButtons,
              rightBarButtons.count <= index + 1 else {
            return
        }
        rightBarButtonItems[index].isHidden = false
    }

    func showLeftBarButton(at index: Int) {
        guard let leftBarButtons = leftBarButtons,
              leftBarButtons.count <= index + 1 else {
            return
        }
        leftBarButtonItems[index].isHidden = false
    }
}

// MARK: - Setup

extension CustomNavigationBar {

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
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
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
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
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
        separatorView.backgroundColor = .systemGray3
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.isHidden = !shouldShowSeparator

        // layout
        addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.leftAnchor.constraint(equalTo: leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.25)
        ])
    }
}
