//
//  FollowingDetailController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 01/06/2023.
//

import UIKit

class FollowingDetailController: UIViewController {

    // MARK: - UI components

    var navBar: CustomNavigationBar!
    var searchBar: UISearchBar!
    var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    let statLalbel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        view.clipsToBounds = true
        view.layer.cornerRadius = 40/2
        return view
    }()

    // MARK: - Properties

    var following = [User]()
    var filteredFollowing = [User]()
    var user: User
    var isSearching: Bool = false

    // MARK: - Life cycle

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        numberOfFollowing()
        fetchFollowing()
    }

    // MARK: - Functions

    private func fetchFollowing() {
        UserManager.shared.fetchFollowingUser(forUid: user.uid) { [weak self] followers in
            DispatchQueue.main.async {
                self?.following = followers
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    private func numberOfFollowing() {
        UserManager.shared.numberOfFollowing(forUser: user.uid) { [weak self] count in
            DispatchQueue.main.async {
                self?.statLalbel.text = "\(count) Following"
            }
        }
    }

    @objc func handleRefresh() {
        isSearching = false
        searchBar.text = ""
        following.removeAll()
        filteredFollowing.removeAll()
        numberOfFollowing()
        fetchFollowing()
    }
}

// MARK: - UISearchBarDelegate

extension FollowingDetailController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredFollowing = following.filter {
            $0.userName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FollowingDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredFollowing.count : following.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowingDetailCell.identifier, for: indexPath) as! FollowingDetailCell
        let user =  isSearching ? filteredFollowing[indexPath.row] : following[indexPath.row]
        cell.user = user
        return cell
    }
}
