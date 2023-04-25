//
//  PlaceholderTextView.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/04/2023.
//

import UIKit

class PlaceholderTextView: UITextView {

  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.text = "Write a caption..."
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    
    font = UIFont.systemFont(ofSize: 17)
    
    addSubview(placeholderLabel)
    NSLayoutConstraint.activate([
      placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor),
      placeholderLabel.topAnchor.constraint(equalTo: topAnchor)
    ])
    
    NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    textContainer.lineFragmentPadding = 0
    textContainerInset = .zero
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
  }
  
  @objc private func textDidChange() {
    placeholderLabel.isHidden = !text.isEmpty
  }
  
}
