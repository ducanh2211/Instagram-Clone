//
//  Extentsion.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit
import Photos

extension UITextField {
  func setPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
    if let left = left {
      let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
      self.leftViewMode = .always
      self.leftView = leftView
    }
    if let right = right {
      let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
      self.rightViewMode = .always
      self.rightView = rightView
    }
  }
}

extension NSMutableAttributedString {
  func appendAttributedString(_ str: String,
                              font: UIFont? = nil,
                              color: UIColor? = nil) -> NSMutableAttributedString {
    
    var attributes = [NSAttributedString.Key: Any]()
    
    if let font = font {
      attributes[.font] = font
    }
    if let color = color {
      attributes[.foregroundColor] = color
    }
    
    let str = NSMutableAttributedString(string: str, attributes: attributes)
    self.append(str)
    return self
  }
}





extension UIColor {
  convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
    self.init(red: CGFloat(red/255),
              green: CGFloat(green/255),
              blue: CGFloat(blue/255),
              alpha: alpha)
  }
}

extension Notification.Name {
  static let textViewTextDidChange = Notification.Name("textViewTextDidChange")
}

extension PHAsset {
  func getImageDataFromAsset() -> Data? {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    var data: Data? = nil
    
    options.isSynchronous = true
    options.resizeMode = .fast
    
    manager.requestImageDataAndOrientation(for: self, options: options) { imageData, _, _, _ in
      if let imageData = imageData {
        data = imageData
      }
    }
    
    return data
  }
  
  func getImageFromAsset(targetSize: CGSize, contentMode: PHImageContentMode = .aspectFit) -> UIImage? {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    var photo: UIImage? = nil
    
    options.isSynchronous = true
    options.deliveryMode = .highQualityFormat
    
    manager.requestImage(for: self,
                         targetSize: targetSize,
                         contentMode: contentMode,
                         options: options) { image, _ in
      if let image = image {
        photo = image
      }
    }
    
    return photo
  }
  
  func getImageAsync(targetSize: CGSize,
                     contentMode: PHImageContentMode = .aspectFit,
                     completion: @escaping (UIImage?) -> Void) -> PHImageRequestID {
    
    let manager = PHImageManager.default()
    
    let id = manager.requestImage(for: self,
                         targetSize: targetSize,
                         contentMode: contentMode,
                         options: nil) { image, _ in
      completion(image)
    }
    
    return id
  }
  
  func getImageFromAsset(targetSize: CGSize,
                         contentMode: PHImageContentMode = .aspectFit,
                         options: PHImageRequestOptions,
                         queue: DispatchQueue,
                         completion: @escaping (UIImage?) -> Void) {
    
    let manager = PHImageManager.default()
    
    queue.async {
      manager.requestImage(for: self,
                           targetSize: targetSize,
                           contentMode: contentMode,
                           options: options) { image, _ in
        guard let image = image else {
          completion(nil)
          return
        }
        completion(image)
      }
    }
  }
}
