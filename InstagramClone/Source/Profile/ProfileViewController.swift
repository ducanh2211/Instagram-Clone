//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    switch cameraAuthorizationStatus {
      case .notDetermined: requestCameraPermission()
      case .authorized: presentCamera()
      case .restricted, .denied: alertCameraAccessNeeded()
      @unknown default: break
    }
  }
  
  func requestCameraPermission() {
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
      guard granted == true else { return }
      self.presentCamera()
    }
  }
  
  func presentCamera() {
    let photoPicker = UIImagePickerController()
    photoPicker.sourceType = .camera
    photoPicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    self.present(photoPicker, animated: true, completion: nil)
  }
  
  func alertCameraAccessNeeded() {
    let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
    
    let alert = UIAlertController(
      title: "Need Camera Access",
      message: "Camera access is required to make full use of this app.",
      preferredStyle: UIAlertController.Style.alert
    )
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
      UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
}
