//
//  PlaceholderTextView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/04/2023.
//

import UIKit

class PlaceholderTextView: UITextView {

    var placeHolderText: String? {
        didSet { placeholderLabel.text = placeHolderText }
    }
    var placeHolderLeftConstraintConstant: CGFloat = 4 {
        didSet {
            placeHolderLeftConstraint.constant = placeHolderLeftConstraintConstant
        }
    }
    var placeHolderTopConstraintConstant: CGFloat = 8 {
        didSet {
            placeHolderTopConstraint.constant = placeHolderTopConstraintConstant
        }
    }

    private var placeHolderLeftConstraint: NSLayoutConstraint!
    private var placeHolderTopConstraint: NSLayoutConstraint!

    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        font = UIFont.systemFont(ofSize: 13)

        addSubview(placeholderLabel)

        placeHolderLeftConstraint = placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: placeHolderLeftConstraintConstant)
        placeHolderTopConstraint = placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: placeHolderTopConstraintConstant)
        NSLayoutConstraint.activate([
            placeHolderLeftConstraint,
            placeHolderTopConstraint
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }

    @objc func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

}
