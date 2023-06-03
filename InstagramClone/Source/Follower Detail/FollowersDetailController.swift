//
//  FollowersDetailController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 01/06/2023.
//

import UIKit

class FollowersDetailController: UIViewController {

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

    var followers = [User]()
    var filteredFollowers = [User]()
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
        numberOfFollowers()
        fetchFollowers()
    }

    // MARK: - Functions

    private func fetchFollowers() {
        UserManager.shared.fetchFollowers(uid: user.uid) { [weak self] followers in
            DispatchQueue.main.async {
                self?.followers = followers
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

    private func numberOfFollowers() {
        UserManager.shared.numberOfFollowers(forUser: user.uid) { [weak self] count in
            DispatchQueue.main.async {
                self?.statLalbel.text = "\(count) Followers"
            }
        }
    }

    @objc func handleRefresh() {
        isSearching = false
        searchBar.text = ""
        followers.removeAll()
        filteredFollowers.removeAll()
        numberOfFollowers()
        fetchFollowers()
    }
}

// MARK: - UISearchBarDelegate

extension FollowersDetailController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        filteredFollowers = followers.filter { follower in
            follower.userName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FollowersDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredFollowers.count : followers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowersDetailCell.identifier, for: indexPath) as! FollowersDetailCell
        let user =  isSearching ? filteredFollowers[indexPath.row] : followers[indexPath.row]
        cell.user = user
        return cell
    }
}
