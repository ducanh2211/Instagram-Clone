//
//  BottomSheetControllerVer2.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 21/05/2023.
//

import UIKit

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
  
  var rootViewController: UIViewController {
    fatalError("You have to override this property")
  }
  
  var settings: BottomSheetSetting {
    return BottomSheetSetting()
  }
  
  var dimmingView: UIView!
  var grabberView: UIView!
  var rootViewTopConstraint: NSLayoutConstraint!
  var rootViewHeightConstraint: NSLayoutConstraint!
  var originCenter: CGPoint = .zero
  
  // MARK: - Life cycle
  override func loadView() {
    let view = UIView()
    dimmingView = UIView()
    grabberView = UIView()
    
    view.addSubview(dimmingView)
    addChildController(rootViewController, toView: view)
    rootViewController.view.addSubview(grabberView)
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupGrabberView()
    setupDimmingView()
    setupRootViewController()
    setupConstraints()
  }
  
  // MARK: - Functions
  @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
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
        removeSheet()
      }
      else if progress > 0.7 {
        removeSheet()
      }
      else {
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
          gestureView.center = self.originCenter
          self.dimmingView.alpha = 1
        }
      }
    }
  }
  
  @objc private func didTapDimmingView() {
    removeSheet()
  }
  
  func showSheet() {
    self.rootViewTopConstraint.constant = -(sheetHeight + spacingFromBottom)
    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
      self.dimmingView.backgroundColor = .black.withAlphaComponent(0.6)
      self.view.layoutIfNeeded()
    }
  }
   
  func removeSheet() {
    self.rootViewTopConstraint.constant = 0
    UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
      self.dimmingView.alpha = 0
      self.view.layoutIfNeeded()
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
  
  // MARK: - Setup
  private func setupGrabberView() {
    grabberView.backgroundColor = .systemGray2
    grabberView.layer.cornerRadius = 2
    grabberView.isHidden = !sheetGrabberVisible
  }
  
  private func setupDimmingView() {
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.isUserInteractionEnabled = true
    dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView)))
  }
  
  private func setupRootViewController() {
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
    rootViewController.view.addGestureRecognizer(
      UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
  }
 
  func setupConstraints() {
    grabberView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

    rootViewTopConstraint = rootViewController.view.topAnchor.constraint(equalTo: view.bottomAnchor)
    
    switch settings.type {
      case .fill:
        rootViewHeightConstraint = rootViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
      case .float:
        rootViewHeightConstraint = rootViewController.view.heightAnchor.constraint(equalToConstant: sheetHeight)
    }
    
    NSLayoutConstraint.activate([
      grabberView.topAnchor.constraint(equalTo: rootViewController.view.topAnchor, constant: 10),
      grabberView.centerXAnchor.constraint(equalTo: rootViewController.view.centerXAnchor),
      grabberView.widthAnchor.constraint(equalToConstant: 36),
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
