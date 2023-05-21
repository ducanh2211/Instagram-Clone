//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class ProfileViewController: UIViewController,
                             ContainerScrollViewDatasource,
                             CustomizableNavigationBar,
                             FakeViewControllerDelegate {

  func didSelectRow(with index: Int) {
    
  }
  
  // MARK: - ContainerScrollViewDatasource
  let minHeaderViewHeight: CGFloat = 0
  let headerViewController: UIViewController = ProfileHeaderViewController()
  let bottomViewController: BottomControllerProvider = ProfileBottomViewController()
  
  // MARK: - Properties
  var navBar: CustomNavigationBar!
  var containerScrollView: ContainerScrollViewController!
  
  private var headerVC: ProfileHeaderViewController {
    return headerViewController as! ProfileHeaderViewController
  }
  
  private let navBarHeight: CGFloat = 44
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    headerVC.delegate = self
    setupView()
  }
  
//  var bottomSheetVC: BottomSheetController!
  
  private func didTapConfigureButton() {
    let fakeVC = FakeViewController()
    fakeVC.delegate = self
    let settings = BottomSheetSetting(type: .fill,
                                      cornerRadius: .both(radius: 10),
                                      sheetHeight: .medium,
                                      grabberVisible: true)

    var bottomSheetVC: BottomSheetController
    bottomSheetVC = BottomSheetController(rootViewController: fakeVC, settings: settings)
    bottomSheetVC.modalPresentationStyle = .overFullScreen
    bottomSheetVC.modalTransitionStyle = .coverVertical
    present(bottomSheetVC, animated: false) {
      bottomSheetVC.show()
    }
  }
  
  // MARK: - Helper
  private func setupView() {
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .systemBackground
    setupNavBar()
    setupContainerScrollView()
    setupConstraints()
  }
  
  private func setupNavBar() {
    let titleButton = AttributedButton(
      title: "duc3385",
      font: .systemFont(ofSize: 24, weight: .bold),
      color: .label
    )
    let configureButton = AttributedButton(
      image: UIImage(systemName: "line.3.horizontal")!,
      completion: { [weak self] in
        self?.didTapConfigureButton()
      }
    )
    let createButton = AttributedButton(
      image: UIImage(systemName: "plus.app")!
    )
    
    navBar = CustomNavigationBar(
      shouldShowSeparator: false,
      leftBarButtons: [titleButton],
      rightBarButtons: [configureButton, createButton]
    )
  }
  
  private func setupContainerScrollView() {
    containerScrollView = ContainerScrollViewController()
    containerScrollView.dataSource = self
    addChildController(containerScrollView)
  }
  
  private func setupConstraints() {
    view.addSubview(navBar)
    navBar.translatesAutoresizingMaskIntoConstraints = false
    containerScrollView.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
      navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
      navBar.heightAnchor.constraint(equalToConstant: navBarHeight),
      
      containerScrollView.view.leftAnchor.constraint(equalTo: view.leftAnchor),
      containerScrollView.view.topAnchor.constraint(equalTo: navBar.bottomAnchor),
      containerScrollView.view.rightAnchor.constraint(equalTo: view.rightAnchor),
      containerScrollView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
