//
//  NewPostController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 28/05/2023.
//

import UIKit

extension NewPostController {
    func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        captionTextView.becomeFirstResponder()
        setupNavBar()
        setupActivityIndicator()
        setupConstraints()
    }

    private func setupNavBar() {
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
        let backButton = AttributedButton(image: image) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        let shareButton = AttributedButton(title: "Share") { [weak self] in
            self?.shareButtonTapped()
        }

        navBar = CustomNavigationBar(title: "New post",
                                     shouldShowSeparator: false,
                                     leftBarButtons: [backButton],
                                     rightBarButtons: [shareButton])
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        view.addSubview(activityIndicator)
        view.addSubview(smallPhotoImageView)
        view.addSubview(captionTextView)

        captionTextViewHeightConstraint = captionTextView.heightAnchor.constraint(equalToConstant: 50)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            activityIndicator.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -12),
            activityIndicator.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 22),
            activityIndicator.heightAnchor.constraint(equalToConstant: 22),

            smallPhotoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            smallPhotoImageView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
            smallPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            smallPhotoImageView.widthAnchor.constraint(equalTo: smallPhotoImageView.heightAnchor, multiplier: idealPhotoAspectRatio),

            captionTextView.leftAnchor.constraint(equalTo: smallPhotoImageView.rightAnchor, constant: 12),
            captionTextView.topAnchor.constraint(equalTo: smallPhotoImageView.topAnchor),
            captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            captionTextViewHeightConstraint
        ])
    }
}
