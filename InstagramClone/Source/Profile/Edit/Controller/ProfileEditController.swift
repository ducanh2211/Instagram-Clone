//
//  ProfileEditViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

extension ProfileEditController {
    
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
        var data: String
    }
}

protocol ProfileEditControllerDelegate: AnyObject {
    func userInfoDidChange()
}

// MARK: - ProfileEditController

class ProfileEditController: UIViewController, CustomizableNavigationBar {
    
    // MARK: - UI components

    let headerView = ProfileEditHeader()
    var navBar: CustomNavigationBar!
    var tableView: UITableView!
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties

    var dataSource: [UserInfoData] {
        didSet { tableView.reloadData() }
    }
    var selectedImage: UIImage? {
        didSet { headerView.profileImage = selectedImage }
    }
    var shouldUpdateProfileImage: Bool {
        return selectedImage != nil
    }
    var shouldUpdateOtherInfo: Bool = false
    var user: User
    weak var delegate: ProfileEditControllerDelegate?
    
    // MARK: - Initializer

    init(user: User) {
        self.user = user
        self.dataSource = [
            .init(type: .name, data: user.fullName),
            .init(type: .userName, data: user.userName),
            .init(type: .bio, data: user.bio)
        ]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    deinit {
        print("DEBUG: ProfileEditController deinit")
    }
    
    // MARK: - Functions

    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    func didTapDoneButton() {
        updateUserInfo()
    }
    
    func updateUserInfo() {
        activityIndicator.startAnimating()
        hideDoneButton()
        disableCancelButton()
        
        let completion = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    print("DEBUG: updateProfileImage error: \(error)")
                    return
                }
                self.delegate?.userInfoDidChange()
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true)
            }
        }
        
        if shouldUpdateProfileImage && shouldUpdateOtherInfo {
            UserManager.shared.updateUserInfo(user, image: selectedImage, updateAvatarOnly: false, completion: completion)
        }
        else if shouldUpdateOtherInfo {
            UserManager.shared.updateUserInfo(user, image: nil, updateAvatarOnly: false, completion: completion)
        }
        else if shouldUpdateProfileImage {
            UserManager.shared.updateUserInfo(user, image: selectedImage, updateAvatarOnly: true, completion: completion)
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.activityIndicator.stopAnimating()
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Helper

    private func hideDoneButton() {
        navBar.hideRightBarButton(at: 0)
    }

    private func disableCancelButton() {
        navBar.disableLeftBarButton(at: 0)
    }
}

// MARK: - UITableViewDataSource

extension ProfileEditController: UITableViewDataSource, UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = UserInfoType(rawValue: indexPath.row) else { return }
        let vc = ProfileEditDetailController(infoType: type, user: user)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.profileImageString = user.avatarUrl
        return headerView
    }
}
