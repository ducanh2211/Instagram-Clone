//
//  ProfileConfigurationController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

fileprivate struct ConfigureSetting {
  var image: UIImage
  var title: String
}

// MARK: - ProfileConfigurationController
class ProfileConfigurationController: UITableViewController {
  
  private let dataSource: [ConfigureSetting] = [
    .init(image: UIImage(named: "vtv24-logo")!, title: "Settings"),
    .init(image: UIImage(named: "vtv24-logo")!, title: "Your activity"),
    .init(image: UIImage(named: "vtv24-logo")!, title: "Saved"),
    .init(image: UIImage(named: "vtv24-logo")!, title: "Favorites"),
  ]
  
  deinit {
    print("DEBUG: deinit ProfileConfigurationController")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    navigationController?.isNavigationBarHidden = true
    tableView.isScrollEnabled = true
    tableView.rowHeight = 55
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                          bottom: 0, right: 0)
    tableView.register(ProfileConfigurationCell.self,
                       forCellReuseIdentifier: ProfileConfigurationCell.identifier)
  }
  
  
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: ProfileConfigurationCell.identifier,
      for: indexPath) as! ProfileConfigurationCell
    cell.setting = dataSource[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIViewController()
    vc.view.backgroundColor = .systemPink
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - ProfileConfigurationCell
fileprivate class ProfileConfigurationCell: UITableViewCell {
  
  static var identifier: String { String(describing: self) }
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.setContentHuggingPriority(.required, for: .horizontal)
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15, weight: .medium)
    label.numberOfLines = 1
    return label
  }()
  
  fileprivate var setting: ConfigureSetting? {
    didSet { configure() }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    guard let setting = setting else { return }
    titleLabel.text = setting.title
    iconImageView.image = setting.image
  }
  
  private func setup() {
    let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
    stack.spacing = 15
    stack.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stack)
    
    NSLayoutConstraint.activate([
      iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
      stack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
    ])
  }
  
}

