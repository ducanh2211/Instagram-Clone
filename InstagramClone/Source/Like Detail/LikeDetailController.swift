//
//  LikeDetailController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 29/05/2023.
//

import UIKit

class LikeDetailController: UIViewController, CustomizableNavigationBar {

    // MARK: - UI components

    var navBar: CustomNavigationBar!
    var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView!
    var tableView: UITableView!
    let refreshControl = UIRefreshControl()

    // MARK: - Properties

    private var likedUsers: [User] = []
    private var filteredUsers: [User] = []
    private var post: Post
    private var isSearching: Bool = false

    // MARK: - Initializer

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchLikedUser()
    }

    // MARK: - Functions

    @objc func handleRefresh() {
        filteredUsers.removeAll()
        isSearching = false
        searchBar.text = ""
        fetchLikedUser()
    }

    private func fetchLikedUser() {
        activityIndicator.startAnimating()
        PostManager.shared.fetchLikedUser(forPost: post.postId) { [weak self] users in
            DispatchQueue.main.async {
                self?.likedUsers = users
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension LikeDetailController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            fetchLikedUser()
            return
        }
        isSearching = true
        filteredUsers = likedUsers.filter { likedUser in
            likedUser.userName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension LikeDetailController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUsers.count : likedUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LikeDetailCell.identifier, for: indexPath) as! LikeDetailCell
        let user =  isSearching ? filteredUsers[indexPath.row] : likedUsers[indexPath.row]
        cell.user = user
        return cell
    }
}


