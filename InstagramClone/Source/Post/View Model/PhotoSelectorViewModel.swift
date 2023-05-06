//
//  PhotoSelectorViewModel.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 24/04/2023.
//

import Foundation
import Photos

class PhotoSelectorViewModel {
  var allAssets = PHFetchResult<PHAsset>()
  var selectedIndex: Int?
  var receivedAssets: (() -> Void)?
  
  deinit {
    print("PhotoSelectorViewModel deinit")
  }
  
  // MARK: - Public
  var numberOfItems: Int { allAssets.count }
  
  var isAssetsEmpty: Bool { numberOfItems == 0 }
  
  func getAssetAtIndex(_ index: Int) -> PHAsset {
    return allAssets[index]
  }
  
  func getAssetAtSelectedIndex() -> PHAsset? {
    guard let index = selectedIndex else { return nil }
    return allAssets[index]
  }
  
  func getPermissionIfNeed() {
    if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
      fetchAssets()
      return
    }
    
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
      if status == .authorized { self.fetchAssets() }
    }
  }
  
  func fetchAssets() {
    let option = PHFetchOptions()
    option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    self.allAssets = PHAsset.fetchAssets(with: .image, options: option)
    self.selectedIndex = (allAssets.count == 0) ? nil : 0
    self.receivedAssets?()
  }
  
  func handlePhotoLibraryChange(_ changeInstance: PHChange) {
    guard let changeDetails = changeInstance.changeDetails(for: allAssets) else { return }
    
    DispatchQueue.main.sync {
      self.allAssets = changeDetails.fetchResultAfterChanges
      self.selectedIndex = 0
      self.receivedAssets?()
    }
  }
}