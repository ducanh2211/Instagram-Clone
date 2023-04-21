//
//  PostViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
import PhotosUI

class PostViewController: UIViewController {
  
  // MARK: - UI components
  private lazy var photoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped))
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
    return imageView
  }()
  
  private let captionTextView: PlaceholderTextView = {
    let textView = PlaceholderTextView()
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    
    
  }
  
  @objc private func photoImageViewTapped() {
    
  }
  
}
