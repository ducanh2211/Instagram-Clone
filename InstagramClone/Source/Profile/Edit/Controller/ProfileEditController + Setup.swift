//
//  ProfileEditViewController + setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 22/05/2023.
//

import UIKit

extension ProfileEditController {
    func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavBar()
        setupActivityIndicator()
        setupConstraints()
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.sectionHeaderHeight = 145
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileEditCell.self, forCellReuseIdentifier: ProfileEditCell.identifier)
        headerView.delegate = self
    }

    private func setupNavBar() {
        let cancelButton = AttributedButton(title: "Cancel",
                                            font: .systemFont(ofSize: 16),
                                            color: .label) { [weak self] in
            self?.didTapCancelButton()
        }

        let doneButton = AttributedButton(title: "Done") { [weak self] in
            self?.didTapDoneButton()
        }

        navBar = CustomNavigationBar(title: "Edit profile",
                                     leftBarButtons: [cancelButton],
                                     rightBarButtons: [doneButton])
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -12),
            activityIndicator.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 22),
            activityIndicator.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
}
