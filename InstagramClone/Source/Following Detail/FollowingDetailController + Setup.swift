//
//  FollowingDetailController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 02/06/2023.
//

import UIKit

extension FollowingDetailController {
    func setupView() {
        view.backgroundColor = .systemBackground
        setupNavBar()
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
        navBar = CustomNavigationBar(title: "Following", shouldShowSeparator: false, leftBarButtons: [backButton])
    }

    private func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 36))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }

    private func setupTableView() {
        tableView = UITableView()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableHeaderView = searchBar
        tableView.dataSource = self
        tableView.register(FollowingDetailCell.self, forCellReuseIdentifier: FollowingDetailCell.identifier)
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(navBar)
        view.addSubview(containerView)
        view.addSubview(tableView)
        containerView.addSubview(statLalbel)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            statLalbel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15),
            statLalbel.topAnchor.constraint(equalTo: containerView.topAnchor),
            statLalbel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15),
            statLalbel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            containerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            containerView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40),

            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: statLalbel.bottomAnchor, constant: 10),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
