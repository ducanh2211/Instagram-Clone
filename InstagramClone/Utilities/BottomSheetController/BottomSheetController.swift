//
//  BottomSheetController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 19/05/2023.
//

import UIKit

//protocol BottomSheetControllerChild {
//  var parentController: BottomSheetController? { get }
//}

class BottomSheetController: UIViewController {
  
  // MARK: - Properties
  var sheetHeight: CGFloat {
    settings.sheetHeight.preferedHeight
  }
  
  var spacingFromLeft: CGFloat {
    settings.type.spacingFromLeft
  }
  
  var spacingFromRight: CGFloat {
    settings.type.spacingFromRight
  }
  
  var spacingFromBottom: CGFloat {
    settings.type.spacingFromBottom
  }
  
  var sheetCorner: BottomSheetCorner {
    settings.cornerRadius
  }
  
  var sheetGrabberVisible: Bool {
    settings.grabberVisible
  }
  
  
  let settings: BottomSheetSetting
  let rootViewController: UIViewController
  var dimmingView: UIView!
  var grabberView: UIView!
  var rootViewTopConstraint: NSLayoutConstraint!
  var rootViewHeightConstraint: NSLayoutConstraint!
  var originCenter: CGPoint = .zero
  
  // MARK: - Initializer
  convenience init(rootViewController: UIViewController) {
    self.init(rootViewController: rootViewController, settings: BottomSheetSetting())
  }
  
  init(rootViewController: UIViewController, settings: BottomSheetSetting) {
    self.rootViewController = rootViewController
    self.settings = settings
    super.init(nibName: nil, bundle: nil)
    setupGrabberView()
    setupDimmingView()
    setupRootViewController()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("DEBUG: Bottom Sheet VC deinit")
  }
  
  override func loadView() {
    let view = UIView()
    view.addSubview(dimmingView)
    addChildController(rootViewController, toView: view)
    rootViewController.view.addSubview(grabberView)
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupConstraints()
  }

  // MARK: - Functions
  @objc func draggingRootView(_ gesture: UIPanGestureRecognizer) {
    guard let gestureView = gesture.view else { return }
    let translate = gesture.translation(in: gestureView.superview).y
    let velocity = gesture.velocity(in: gestureView.superview).y
    let translatedFromOrigin = gestureView.center.y - self.originCenter.y
    let progress = translatedFromOrigin / gestureView.bounds.height
    
    if gesture.state == .began {
      self.originCenter = gestureView.center
    }
    
    else if gesture.state == .changed {
      if (velocity <= 0 && translatedFromOrigin <= 0) {
        gestureView.center.y = gestureView.center.y + translate / 10
      }
      else {
        gestureView.center.y = gestureView.center.y + translate
        dimmingView.alpha = 1 - progress
      }
      gesture.setTranslation(.zero, in: gestureView.superview)
    }
    
    else if gesture.state == .ended || gesture.state == .cancelled {
      if velocity > 1200 {
        remove()
      }
      else if progress > 0.7 {
        remove()
      }
      else {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
          gestureView.center = self.originCenter
          self.dimmingView.alpha = 1
        }
      }
    }
  }
  
  @objc func didTapDimmingView() {
    remove()
  }
  
  func show() {
    self.rootViewTopConstraint.constant = -(sheetHeight + spacingFromBottom)
    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
      self.dimmingView.backgroundColor = .black.withAlphaComponent(0.6)
      self.view.layoutIfNeeded()
    }
  }
   
  func remove() {
    self.rootViewTopConstraint.constant = 0
    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
      self.dimmingView.alpha = 0
      self.view.layoutIfNeeded()
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
  
  // MARK: - Setup
  func setupGrabberView() {
    grabberView = UIView()
    grabberView.backgroundColor = .systemGray2
    grabberView.layer.cornerRadius = 2
    grabberView.isHidden = !sheetGrabberVisible
  }
  
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.isUserInteractionEnabled = true
    dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView)))
  }
  
  func setupRootViewController() {
    let cornerRadius: CGFloat
    switch sheetCorner {
      case .top(let radius):
        cornerRadius = radius
        rootViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      case .bottom(let radius):
        cornerRadius = radius
        rootViewController.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
      case .both(let radius):
        cornerRadius = radius
        rootViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                                       .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    rootViewController.view.layer.cornerRadius = cornerRadius
    rootViewController.view.clipsToBounds = true
    rootViewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(draggingRootView(_:))))
  }
  
  func setupConstraints() {
    grabberView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

    rootViewTopConstraint = rootViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor)
    rootViewHeightConstraint = rootViewController.view.heightAnchor.constraint(equalToConstant: sheetHeight)
    
    NSLayoutConstraint.activate([
      grabberView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor, constant: 10),
      grabberView.centerXAnchor.constraint(equalTo: rootViewController.view.centerXAnchor),
      grabberView.widthAnchor.constraint(equalToConstant: 44),
      grabberView.heightAnchor.constraint(equalToConstant: 4),
      
      dimmingView.leftAnchor.constraint(equalTo: view.leftAnchor),
      dimmingView.rightAnchor.constraint(equalTo: view.rightAnchor),
      dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
      dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      rootViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: spacingFromLeft),
      rootViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -spacingFromRight),
      rootViewHeightConstraint,
      rootViewTopConstraint
    ])
  }
  
}
