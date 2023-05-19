//
//  PHAsset + Extenstion.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit
import Photos

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
  
  func getImageFromAsset(targetSize: CGSize,
                         contentMode: PHImageContentMode = .aspectFit) -> UIImage? {
    
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
