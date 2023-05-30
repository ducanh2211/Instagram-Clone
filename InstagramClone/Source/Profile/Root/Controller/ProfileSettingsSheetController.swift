//
//  ProfileSettingsSheetController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 21/05/2023.
//

import UIKit

fileprivate let bottomSheetHeight: CGFloat = 520

class ProfileSettingsSheetController: BottomSheetViewController {

    private let containerView = UIView()
    private var tableView: UITableView!

    override var rootView: UIView {
        return containerView
    }

    override var settings: BottomSheetSetting {
        return BottomSheetSetting(type: .fill,
                                  cornerRadius: .top(radius: 15),
                                  sheetHeight: .custom(height: bottomSheetHeight),
                                  grabberVisible: true)
    }

    private lazy var dataSource: [ConfigureCellDatasource] = [
        .init(image: createImage(name: "gearshape"), title: "Settings"),
        .init(image: createImage(name: "clock"), title: "Your activity"),
        .init(image: createImage(name: "clock.arrow.circlepath"), title: "Archive"),
        .init(image: createImage(name: "qrcode.viewfinder"), title: "QR code"),
        .init(image: createImage(name: "bookmark"), title: "Saved"),
        .init(image: createImage(name: "creditcard"), title: "Orders and payments"),
        .init(image: createImage(name: "list.star"), title: "Close Friends"),
        .init(image: createImage(name: "star"), title: "Favorites")
    ]

    override func viewDidLoad() {
        setupTableView()
        setupContainerView()
        super.viewDidLoad()
    }

    private func createImage(name: String) -> UIImage {
        let weight = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: name, withConfiguration: weight)
        return image!
    }

    // MARK: - Setup

    private func setupContainerView() {
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
    }

    override func setupConstraints() {
        super.setupConstraints()

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableView.heightAnchor.constraint(equalToConstant: bottomSheetHeight - 25)
        ])
    }
}

// MARK: - UITableViewDataSource

extension ProfileSettingsSheetController: UITableViewDataSource, UITableViewDelegate {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

