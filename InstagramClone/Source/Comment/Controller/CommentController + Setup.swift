//
//  CommentController + Setup.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 03/06/2023.
//

import UIKit

extension CommentController {
    func setupView() {
        view.backgroundColor = .systemBackground
        setupNavBar()
        setupCollectionView()
        setupInputSection()
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

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsVerticalScrollIndicator = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        collectionView.register(CommentHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CommentHeader.identifier)
        collectionView.register(LoadingIndicatorFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: LoadingIndicatorFooterView.identifier)
    }

    private func setupInputSection() {
        inputSection = CommentInputView()
        inputSection.delegate = self
        inputSection.profileImageString = currentUser.avatarUrl
    }

    private func setupConstraints() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        inputSection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)
        view.addSubview(collectionView)
        view.addSubview(inputSection)

        inputSectionBottomConstraint = inputSection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),

            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -inputSection.initialHeight),

            inputSection.leftAnchor.constraint(equalTo: view.leftAnchor),
            inputSection.rightAnchor.constraint(equalTo: view.rightAnchor),
            inputSectionBottomConstraint
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

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(40)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        if post.caption.isEmpty {
            section.boundarySupplementaryItems = [footer]
        } else {
            section.boundarySupplementaryItems = [header, footer]
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
}
