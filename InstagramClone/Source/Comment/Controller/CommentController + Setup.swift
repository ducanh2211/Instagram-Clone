//
//  CommentController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 29/05/2023.
//

import UIKit

extension CommentController {
    func setupView() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupActivityIndicator()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavBar() {
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.backward", withConfiguration: imageWeight)!
        let backButton = AttributedButton(image: image) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navBar = CustomNavigationBar(title: "Comments", shouldShowSeparator: true, leftBarButtons: [backButton])
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        collectionView.register(CommentHeader.self,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CommentHeader.identifier)
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        view.addSubview(activityIndicator)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            activityIndicator.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -12),
            activityIndicator.centerYAnchor.constraint(equalTo: navBar.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 22),
            activityIndicator.heightAnchor.constraint(equalToConstant: 22),

            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -commentSection.initialHeight)
        ])
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(150)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
}
