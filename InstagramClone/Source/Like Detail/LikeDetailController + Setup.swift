//
//  LikeDetailController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 30/05/2023.
//

import UIKit

extension LikeDetailController {

    func setupView() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupActivityIndicator()
        setupSearchBar()
        setupTableView()
        setupConstraints()
    }

    private func setupNavBar() {
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
        let backButton = AttributedButton(image: image) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navBar = CustomNavigationBar(title: "Likes", shouldShowSeparator: true, leftBarButtons: [backButton])
    }

    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableHeaderView = searchBar
        tableView.dataSource = self
        tableView.register(LikeDetailCell.self, forCellReuseIdentifier: LikeDetailCell.identifier)
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        view.addSubview(activityIndicator)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            activityIndicator.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -12),
            activityIndicator.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 22),
            activityIndicator.heightAnchor.constraint(equalToConstant: 22),

            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
