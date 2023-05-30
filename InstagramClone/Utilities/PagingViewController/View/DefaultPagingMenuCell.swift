//
//  DefaultPagingMenuCell.swift
//  NestedScrollView
//
//  Created by Đức Anh Trần on 12/05/2023.
//

import UIKit

class DefaultPagingMenuCell: UICollectionViewCell, PagingMenuCell {
    
    static var identifier: String { String(describing: self) }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFit
        imv.clipsToBounds = true
        return imv
    }()
    
    // MARK: - Properties

    var settings: PagingMenuSettings? {
        didSet { configure() }
    }
    override var isSelected: Bool {
        didSet { configure() }
    }
    var menuItem: DefaultMenuItem!
    
    // MARK: - Intializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions

    func configurePagingCell(with menuItem: DefaultMenuItem) {
        self.menuItem = menuItem
        if let title = menuItem.title {
            titleLabel.text = title
            imageView.isHidden = true
        }
        else if let image = menuItem.normalImage {
            titleLabel.isHidden = true
            imageView.image = image
        }
    }
    
    private func configure() {
        guard let settings = settings else {
            return
        }
        if isSelected {
            titleLabel.textColor = settings.selectedColor
            titleLabel.font = settings.selectedFont
            imageView.image = menuItem.selectedImage ?? menuItem.normalImage
        } else {
            titleLabel.textColor = settings.normalColor
            titleLabel.font = settings.normalFont
            imageView.image = menuItem.normalImage
        }
    }
    
    // MARK: - Helper

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22),
        ])
    }
    
}
