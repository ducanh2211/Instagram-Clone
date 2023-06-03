//
//  CustomSeachView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 25/05/2023.
//

import UIKit

protocol UserSearchViewDelegate: AnyObject {
    func showSearchView()
    func hideSearchView()
    func didSelectUser(_ user: User)
}

class UserSearchView: UIView {

    // MARK: - Properties

    weak var delegate: UserSearchViewDelegate?
    var searchBar: UISearchBar!
    var tableView: UITableView!
    private var tableViewConstraints = [NSLayoutConstraint]()
    var isPresenting: Bool = false
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var animationDuration: TimeInterval = 0.2
    private var searchedUser = [User]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
        setupTableView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func addTableView() {
        delegate?.showSearchView()

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        UIView.animate(withDuration: animationDuration, delay: 0) {
            self.tableView.alpha = 1
        }
    }

    private func removeTableView() {
        UIView.animate(withDuration: animationDuration, delay: 0) {
            self.tableView.alpha = 0
        } completion: { _ in
            self.searchedUser.removeAll()
            self.tableView.reloadData()
            self.tableView.removeFromSuperview()
            self.delegate?.hideSearchView()
        }
    }
}

// MARK: - UISearchBarDelegate

extension UserSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pendingRequestWorkItem?.cancel()

        let requestWorkItem = DispatchWorkItem { [weak self] in
            UserManager.shared.searchUser(with: searchText.lowercased()) { users in
                DispatchQueue.main.async {
                    self?.searchedUser = users
                    self?.tableView.reloadData()
                }
            }
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: requestWorkItem)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isPresenting = true
        addTableView()
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isPresenting = false
        removeTableView()
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension UserSearchView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchUserTableViewCell.identifier, for: indexPath) as! SearchUserTableViewCell
        let user = searchedUser[indexPath.row]
        cell.configure(with: user)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectUser(searchedUser[indexPath.row])
    }
}

// MARK: - Setup

extension UserSearchView {
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.tintColor = .label
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor.systemBackground
        searchBar.delegate = self
    }

    private func setupTableView() {
        tableView = UITableView()
        tableView.backgroundColor = UIColor.systemBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchUserTableViewCell.self, forCellReuseIdentifier: SearchUserTableViewCell.identifier)
    }

    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
