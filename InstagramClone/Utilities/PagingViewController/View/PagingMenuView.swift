//
//  DAPagingMenu.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 11/05/2023.
//

import UIKit

// MARK: - Protocol
protocol PagingMenuViewDelegate: AnyObject {
    /// Dùng để update transition khi menu item được select.
    /// - Parameters:
    ///   - pagingMenuView: menu view.
    ///   - index: index của item được select.
    func pagingMenuView(_ pagingMenuView: PagingMenuView, didSelectItemAt index: Int)
}

// MARK: - PagingMenuView
class PagingMenuView: UIView {

    var collectionView: UICollectionView!
    private var footerView: MenuBottomIndicator!
    var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.isHidden = true
        return view
    }()

    // MARK: - Properties

    var menuItems: [DefaultMenuItem] = [] {
        didSet { menuItemsDidSet() }
    }
    private var layout: UICollectionViewCompositionalLayout {
        let manager = PagingMenuCollectionViewLayout(numberOfItems: numberOfItems, settings: settings)
        return manager.createLayout()
    }
    let settings: PagingMenuSettings
    weak var delegate: PagingMenuViewDelegate?

    /// Fake số lượng item ban đầu, số lượng thực tế sẽ có sau khi `menuItems` didSet.
    private var numberOfItems: Int = 1
    private var currentIndex: Int = 0
    private var cachedItemSize: [Int: CGSize] = [:]

    // MARK: - Initializer

    init(settings: PagingMenuSettings) {
        self.settings = settings
        super.init(frame: .zero)
        setupCollectionView()
        setupIndicatorView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func setupIndicatorView() {
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.leftAnchor.constraint(equalTo: leftAnchor),
            indicatorView.rightAnchor.constraint(equalTo: rightAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 1),
            indicatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func menuItemsDidSet() {
        numberOfItems = menuItems.count
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.reloadData()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(collectionView)
        collectionView.pinToView(self)

        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            DefaultPagingMenuCell.self,
            forCellWithReuseIdentifier: DefaultPagingMenuCell.identifier
        )
        collectionView.register(
            MenuBottomIndicator.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: MenuBottomIndicator.identifier
        )
    }

}

// MARK: - PagingMenuViewUpdatable

extension PagingMenuView {
    func didTransitioning(currentIndex: Int, progress: CGFloat, indexJustChanged: Bool) {
        footerView.didTransitioning(currentIndex: currentIndex, progress: progress)

        if indexJustChanged {
            updateCellState(atIndex: currentIndex, previousIndex: self.currentIndex)
        }
        self.currentIndex = currentIndex
    }

    /// Update property `isSelected` của `selected cell` và `previous cell` để nó có thể tự configure appearence.
    private func updateCellState(atIndex: Int, previousIndex: Int) {
        let selectedCell = collectionView.cellForItem(at: IndexPath(item: atIndex, section: 0))
        let previousCell = collectionView.cellForItem(at: IndexPath(item: previousIndex, section: 0))
        selectedCell?.isSelected = true
        previousCell?.isSelected = false
    }
}

// MARK: - UICollectionViewDelegate

extension PagingMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let newIndex = indexPath.item
        if currentIndex == newIndex { return false }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newIndex = indexPath.item
        let previousIndex = currentIndex
        currentIndex = newIndex
        collectionView.isUserInteractionEnabled = false

        footerView.adjustIndicatorPosition(withNewIndex: newIndex, completion: {
            collectionView.isUserInteractionEnabled = true
        })

        delegate?.pagingMenuView(self, didSelectItemAt: newIndex)
        updateCellState(atIndex: newIndex, previousIndex: previousIndex)
    }
}

// MARK: - UICollectionViewDataSource

extension PagingMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultPagingMenuCell.identifier, for: indexPath) as! DefaultPagingMenuCell
        let menuItem = menuItems[indexPath.item]
        cell.configurePagingCell(with: menuItem)
        cell.settings = settings
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MenuBottomIndicator.identifier,
                for: indexPath) as! MenuBottomIndicator
            footerView = footer
            footer.settings = settings

            let layout = (collectionView.collectionViewLayout) as? UICollectionViewCompositionalLayout
            footer.layout = layout
            return footer
        }
        return UICollectionReusableView()
    }
}
