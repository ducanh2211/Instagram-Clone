//
//  PhotoSelectorController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 23/04/2023.
//

import UIKit

extension PhotoSelectorController {

    // MARK: View
    func setupView() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .white
        setupNavBar()
        setupCollectionView()
        setupConstraints()
    }

    private func setupNavBar() {
        let closeButton = AttributedButton(image: UIImage(systemName: "xmark")!) { [weak self] in
            self?.didTapCloseButton()
        }

        let nextButton = AttributedButton(title: "Next") { [weak self] in
            self?.didTapNextButton()
        }

        navBar = CustomNavigationBar(title: "New post",
                                     shouldShowSeparator: false,
                                     leftBarButtons: [closeButton],
                                     rightBarButtons: [nextButton])
    }

    private func setupConstraints() {
        view.addSubview(navBar)
        view.addSubview(collectionView)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            PhotoSelectorCell.self,
            forCellWithReuseIdentifier: PhotoSelectorCell.identifier
        )
        collectionView.register(
            PhotoSelectorHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PhotoSelectorHeader.identifier
        )
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemInsets: CGFloat = 0.5
        let numberOfItemsInGroup: CGFloat = 4

        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / numberOfItemsInGroup),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: itemInsets, leading: itemInsets,
            bottom: itemInsets, trailing: itemInsets
        )

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1 / numberOfItemsInGroup)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: itemInsets,
            bottom: 0, trailing: itemInsets
        )

        // Supplementary items
        let supplementaryItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let supplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: supplementaryItemSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        supplementaryItem.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [supplementaryItem]

        return UICollectionViewCompositionalLayout(section: section)
    }
}
