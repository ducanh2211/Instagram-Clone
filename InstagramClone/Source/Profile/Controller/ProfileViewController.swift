//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class ProfileViewController: UIViewController, MasterScrollViewDatasource {
  
  // MARK: - MasterScrollViewDatasource
  var minHeaderViewHeight: CGFloat {
    return view.safeAreaInsets.top + statusViewHeight
  }
  
  var headerViewController: UIViewController = ProfileHeaderViewController()
  
  var bottomViewController: BottomControllerProvider = ProfileBottomViewController()
  
  // MARK: - Properties
  private var statusView: ProfileStatusView!
  private var containerScrollView: ContainerScrollViewController!
  
  private let statusViewHeight: CGFloat = 44
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    setupStatusView()
    setupMasterScrollView()
  }
  
  private func setupStatusView() {
    statusView = ProfileStatusView()
    statusView.title = "ducanh2211"
    statusView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(statusView)
    
    NSLayoutConstraint.activate([
      statusView.leftAnchor.constraint(equalTo: view.leftAnchor),
      statusView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      statusView.rightAnchor.constraint(equalTo: view.rightAnchor),
      statusView.heightAnchor.constraint(equalToConstant: statusViewHeight)
    ])
  }
  
  private func setupMasterScrollView() {
    let vc = ContainerScrollViewController()
    vc.dataSource = self
    addChildController(vc)
    vc.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      vc.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      vc.view.topAnchor.constraint(equalTo: statusView.bottomAnchor),
      vc.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
}
