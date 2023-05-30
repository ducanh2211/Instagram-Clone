//
//  ProfileEditAvatarSheetController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 22/05/2023.
//

import UIKit

fileprivate var bottomSheetHeight: CGFloat = 250

protocol ProfileEditAvatarSheetControllerDelegate: AnyObject {
  func didSelectOption(_ sheetController: ProfileEditAvatarSheetController, option: ProfileEditAvatarSheetController.Options)
}

class ProfileEditAvatarSheetController: BottomSheetViewController {
  
  enum Options: Int {
    case photo
    case camera
  }
  
  // MARK: - Properties

  weak var delegate: ProfileEditAvatarSheetControllerDelegate?
  private let profileImageString: String
  
  private var containerView = UIView()
  private var profileImageView: UIImageView!
  private var separatorView: UIView!
  private var tableView: UITableView!
  
  override var rootView: UIView {
    return containerView
  }
  
  override var settings: BottomSheetSetting {
    return BottomSheetSetting(type: .float(leftSpacing: 0, rightSpacing: 0, bottomSpacing: 0),
                              cornerRadius: .top(radius: 15),
                              sheetHeight: .custom(height: bottomSheetHeight),
                              grabberVisible: true)
  }
  
  private lazy var dataSource: [ConfigureCellDatasource] = [
    .init(image: createImage(systemName: "photo"), title: "Choose from library"),
    .init(image: createImage(systemName: "camera"), title: "Take photo")
  ]
  
  // MARK: - Initializer

  init(profileImageString: String) {
    self.profileImageString = profileImageString
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("DEBUG: ProfileEditAvatarSheetController deinit")
  }
  
  override func viewDidLoad() {
    setupProfileImageView()
    setupSeparatorView()
    setupTableView()
    setupContainerView()
    super.viewDidLoad()
  }
  
  // MARK: - Functions

  private func createImage(systemName: String) -> UIImage {
    let weight = UIImage.SymbolConfiguration(weight: .medium)
    let image = UIImage(systemName: systemName, withConfiguration: weight)
    return image!
  }
  
  override func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    return
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    separatorView.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
      profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      profileImageView.widthAnchor.constraint(equalToConstant: 44),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
      
      separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
      separatorView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
      separatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
      separatorView.heightAnchor.constraint(equalToConstant: 0.5),
      
      tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
      tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
      tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
    ])
  }
}

// MARK: - Setup

extension ProfileEditAvatarSheetController {
  private func setupContainerView() {
    containerView.addSubview(profileImageView)
    containerView.addSubview(separatorView)
    containerView.addSubview(tableView)
    containerView.backgroundColor = .systemBackground
  }
  
  private func setupTableView() {
    tableView = UITableView()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(ProfileConfigurationCell.self, forCellReuseIdentifier: ProfileConfigurationCell.identifier)
    tableView.isScrollEnabled = false
    tableView.rowHeight = 50
    tableView.separatorStyle = .none
  }
  
  private func setupProfileImageView() {
    profileImageView = UIImageView()
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.clipsToBounds = true
    profileImageView.layer.cornerRadius = 44/2
    profileImageView.sd_setImage(with: URL(string: profileImageString), placeholderImage: UIImage(named: "user"), context: nil)
  }
  
  private func setupSeparatorView() {
    separatorView = UIView()
    separatorView.backgroundColor = .systemGray4
  }
}

// MARK: - UITableViewDataSource

extension ProfileEditAvatarSheetController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: ProfileConfigurationCell.identifier,
      for: indexPath) as! ProfileConfigurationCell
    cell.setting = dataSource[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.removeSheet()
    guard let option = Options(rawValue: indexPath.row) else { return }
    delegate?.didSelectOption(self, option: option)
  }
}
