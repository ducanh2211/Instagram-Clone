//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class ProfileViewController: UIViewController, ContainerScrollViewDatasource {
  
  // MARK: - ContainerScrollViewDatasource
  let minHeaderViewHeight: CGFloat = 0
  
  let headerViewController: UIViewController = ProfileHeaderViewController()
  
  let bottomViewController: BottomControllerProvider = ProfileBottomViewController()
  
  // MARK: - Properties
  private var navbar: CustomNavigationBar!
  private var containerScrollView: ContainerScrollViewController!
  
  private let statusViewHeight: CGFloat = 44
  
  private var headerVC: ProfileHeaderViewController {
    return headerViewController as! ProfileHeaderViewController
  }
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    headerVC.delegate = self
    setupNavBar()
    setupContainerScrollView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  // MARK: - Helper
  private func setupNavBar() {
    let titleButton = AttributedButton(title: "duc3385",
                                       font: .systemFont(ofSize: 24, weight: .bold),
                                       color: .label)
    
    let createButton = AttributedButton(image: UIImage(systemName: "plus.app")!)
    let configureButton = AttributedButton(image: UIImage(systemName: "line.3.horizontal")!)
    
    navbar = CustomNavigationBar(shouldShowSeparator: false,
                                 leftBarButtons: [titleButton],
                                 rightBarButtons: [createButton, configureButton])
    
    view.addSubview(navbar)
    navbar.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      navbar.leftAnchor.constraint(equalTo: view.leftAnchor),
      navbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navbar.rightAnchor.constraint(equalTo: view.rightAnchor),
      navbar.heightAnchor.constraint(equalToConstant: statusViewHeight)
    ])
  }
  
  private func presentSheetVC() {
    let vc = ProfileConfigurationController()
    if let sheet = vc.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.preferredCornerRadius = 15
      sheet.prefersGrabberVisible = true
    }
    present(vc, animated: true)
  }
  
  private func setupContainerScrollView() {
    let vc = ContainerScrollViewController()
    vc.dataSource = self
    addChildController(vc)
    vc.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      vc.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      vc.view.topAnchor.constraint(equalTo: navbar.bottomAnchor),
      vc.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
}

// MARK: - ProfileHeaderViewControllerDelegate
extension ProfileViewController: ProfileHeaderViewControllerDelegate {
  
  func didTapFollowOrEditButton() {
    let vc = ProfileEditViewController()
    let nav = UINavigationController(rootViewController: vc)
    nav.modalPresentationStyle = .fullScreen
    present(nav, animated: true)
  }
  
  func didTapMessageOrShareButton() {
    
  }
  
}
