//
//  PhotoSelectorViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 18/04/2023.
//

import UIKit
import Photos

class PhotoSelectorViewController: UIViewController, CustomizableNavigationBar {
  
  // MARK: - Properties
  private let viewModel = PhotoSelectorViewModel()
  private var headerView: PhotoSelectorHeader?
//  private let assetQueue = DispatchQueue(label: "get.image.asset.queue")
  
//  let numberOfItemsInGroup: CGFloat = 4
//  lazy var itemSize: CGSize = {
//    let screenWidth = UIScreen.main.bounds.width
//    return CGSize(width: screenWidth / numberOfItemsInGroup,
//                  height: screenWidth / numberOfItemsInGroup)
//  }()
  
  // MARK: - UI components
  var navBar: CustomNavigationBar!
  var collectionView: UICollectionView!
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    registerLibraryObserver()
    bindViewModel()
  }
  
  deinit {
    unregisterLibraryObserver()
    print("PhotoSelectorViewController deinit")
  }
  
  // MARK: - Functions
  private func bindViewModel() {
    viewModel.receivedAssets = { [weak self] in
      DispatchQueue.main.async {
        self?.collectionView.reloadData()        
      }
    }
    viewModel.getPermissionIfNeed()
  }
  
  @objc func didTapCloseButton() {
    self.dismiss(animated: true)
  }
  
  @objc func didTapNextButton() {
    if let asset = viewModel.getAssetAtSelectedIndex() {
//      let viewModel = NewPostViewModel()
      let vc = NewPostViewController(asset: asset)
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  private func registerLibraryObserver() {
    PHPhotoLibrary.shared().register(self)
  }
  
  private func unregisterLibraryObserver() {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }
  
}

// MARK: - UICollectionViewDataSource
extension PhotoSelectorViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfItems
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PhotoSelectorCell.identifier,
      for: indexPath
    ) as! PhotoSelectorCell
        
    let asset = viewModel.getAssetAtIndex(indexPath.item)
//    cell.assetQueue = self.assetQueue
    cell.configure(withAsset: asset)
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension PhotoSelectorViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let index = indexPath.item
    viewModel.selectedIndex = index
    if let asset = viewModel.getAssetAtSelectedIndex() {
      self.headerView?.configure(withAsset: asset)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    
    guard
      kind == UICollectionView.elementKindSectionHeader,
      indexPath.section == 0
    else {
      return UICollectionReusableView()
    }
    
    let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: PhotoSelectorHeader.identifier,
      for: indexPath
    ) as! PhotoSelectorHeader
    
    self.headerView = header
    self.headerView?.delegate = self
    
    if let asset = viewModel.getAssetAtSelectedIndex() {
      header.configure(withAsset: asset)
    }
    
    return header
  }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotoSelectorViewController: PhotoSelectorHeaderDelegate,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate {
  
  func didTapCameraButton() {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = self
    present(picker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
     
    PHPhotoLibrary.shared().performChanges {
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    } completionHandler: { success, error in
      if success {
        DispatchQueue.main.async {
          self.dismiss(animated: true)
        }
      }
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}

// MARK: - PHPhotoLibraryChangeObserver
extension PhotoSelectorViewController: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    viewModel.handlePhotoLibraryChange(changeInstance)
  }
}
