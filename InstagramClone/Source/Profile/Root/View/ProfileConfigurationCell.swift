//
//  ProfileConfigurationCell.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 21/05/2023.
//

import UIKit

struct ConfigureCellDatasource {
  var image: UIImage
  var title: String
}

class ProfileConfigurationCell: UITableViewCell {

  static var identifier: String { String(describing: self) }
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.tintColor = .label
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15)
    label.numberOfLines = 1
    return label
  }()
  
  
  var setting: ConfigureCellDatasource? {
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
      stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -15),
      stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
    ])
  }
  
}
