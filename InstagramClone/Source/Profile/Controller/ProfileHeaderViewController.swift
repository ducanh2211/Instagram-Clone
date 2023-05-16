//
//  ProfileHeaderViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

class ProfileHeaderViewController: UIViewController {
  
  
  private var headerView: ProfileHeaderView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupHeaderView()
  }
  
  
  private func setupHeaderView() {
    headerView = ProfileHeaderView()
    headerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(headerView)
    
    NSLayoutConstraint.activate([
      headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
      headerView.topAnchor.constraint(equalTo: view.topAnchor),
      headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
      headerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}
