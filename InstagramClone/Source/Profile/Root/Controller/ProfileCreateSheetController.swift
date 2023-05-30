//
//  ProfileConfigurationController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/05/2023.
//

import UIKit

fileprivate let bottomSheetHeight: CGFloat = 450

class ProfileCreateSheetController: BottomSheetViewController {

    private let containerView = UIView()
    private var titleLabel: UILabel!
    private var separatorView: UIView!
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
        .init(image: createImage(name: "play.rectangle"), title: "Reel"),
        .init(image: createImage(name: "squareshape.split.3x3"), title: "Post"),
        .init(image: createImage(name: "goforward.plus"), title: "Story"),
        .init(image: createImage(name: "heart.circle"), title: "Story Highlight"),
        .init(image: createImage(name: "dot.radiowaves.left.and.right"), title: "Live"),
        .init(image: createImage(name: "book"), title: "Guide")
    ]

    // MARK: - Life cycle

    override func viewDidLoad() {
        setupTitleLabel()
        setupSeparatorView()
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
        containerView.addSubview(titleLabel)
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
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Create"
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.numberOfLines = 1
    }

    private func setupSeparatorView() {
        separatorView = UIView()
        separatorView.backgroundColor = .systemGray2
    }

    override func setupConstraints() {
        super.setupConstraints()

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),

            separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            separatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            separatorView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),

            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableView.heightAnchor.constraint(equalToConstant: bottomSheetHeight - 35 - 12)
        ])
    }
}

// MARK: - UITableViewDataSource

extension ProfileCreateSheetController: UITableViewDataSource, UITableViewDelegate {
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
