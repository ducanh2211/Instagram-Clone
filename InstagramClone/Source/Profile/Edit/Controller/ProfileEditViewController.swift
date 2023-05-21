//
//  ProfileEditViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

extension ProfileEditViewController {
  
  enum UserInfoType: Int {
    case name, userName, bio
    
    var description: String {
      switch self {
        case .name: return "Name"
        case .userName: return "Username"
        case .bio: return "Bio"
      }
    }
  }
  
  struct UserInfoData {
    var type: UserInfoType
    var data: String?
  }
  
}

// MARK: - ProfileEditViewController
class ProfileEditViewController: UIViewController, CustomizableNavigationBar {
  
  // MARK: - Properties
  var dataSource: [UserInfoData] = [
    .init(type: .name, data: "Duc Anh"),
    .init(type: .userName, data: "duc3385"),
    .init(type: .bio, data: "I'm something of developer myself. I'm something of developer myself. I'm something of developer myself")
  ]
  
  var navBar: CustomNavigationBar!
  private let headerView = ProfileEditHeader()
  private var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  deinit {
    print("DEBUG: profile edit deinit")
  }
  
  // MARK: - Functions
  @objc private func cancelButtonDidTap() {
    dismiss(animated: true)
  }
  
  @objc private func doneButtonDidTap() {
    dismiss(animated: true)
  }
  
  private func setupView() {
    navigationController?.isNavigationBarHidden = true
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    print("DEBUG: \(navigationController?.interactivePopGestureRecognizer)")
    view.backgroundColor = .systemBackground
    setupTableView()
    setupNavBar()
    setupConstraints()
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 50
    tableView.estimatedSectionHeaderHeight = 100
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
      self?.dismiss(animated: true)
    }
    
    let doneButton = AttributedButton(title: "Done") { [weak self] in
      self?.dismiss(animated: true)
    }
    
    navBar = CustomNavigationBar(title: "Edit profile",
                                 leftBarButtons: [cancelButton],
                                 rightBarButtons: [doneButton])
  }
  
  private func setupConstraints() {
    navBar.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(navBar)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
      navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
      navBar.heightAnchor.constraint(equalToConstant: 44),
      
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
}

// MARK: - ProfileEditHeaderDelegate
extension ProfileEditViewController: ProfileEditHeaderDelegate {
  
  func didTapEditAvatarButton() {
    
  }
  
}

// MARK: - UITableViewDataSource
extension ProfileEditViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: ProfileEditCell.identifier,
      for: indexPath) as! ProfileEditCell
    cell.configure(with: dataSource[indexPath.row])
    return cell
  }
  
}

// MARK: - UITableViewDelegate
extension ProfileEditViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if let type = UserInfoType(rawValue: indexPath.row), type == .name {
      return
    }
    
    let vc = ProfileDetailEditViewController(userInfo: dataSource[indexPath.row])
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }

}

