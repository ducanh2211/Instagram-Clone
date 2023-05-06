//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

/// Là ViewController hiển thị thông tin của user.
///
/// Layout được chia làm 3 phần tương ứng với 3 section.
/// "Header": từ đầu đến follow button,
/// "Story": phần hightlight story của user,
/// "Photo": chứa toàn bộ photo mà user đã đăng.
///
class ProfileViewController: UIViewController {
  
  /// Enum dùng để phân chia collection view ra làm 3 section.
  enum SectionType: Int, CaseIterable {
    case header
    case story
    case photo
  }
  var colors: [UIColor] = [.systemPink, .systemBlue, .systemMint, .systemBrown, .systemGray, .systemGreen, .systemYellow]
  // MARK: - UI components
  
  lazy var statusView: ProfileStatusView = {
    let view = ProfileStatusView()
    view.title = "duc3385"
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  var collectionView: UICollectionView!
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SectionType.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    
    switch SectionType(rawValue: section) {
      case .header: return 1
      case .story: return 7
      case .photo: return 1
      default: return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let sectionType = SectionType(rawValue: indexPath.section) else {
      return UICollectionViewCell()
    }
    
    if sectionType == .header {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProfileHeaderCell.identifier,
        for: indexPath
      ) as! ProfileHeaderCell
      return cell
    }
    
    else if sectionType == .story {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProfileStoryCell.identifier,
        for: indexPath
      ) as! ProfileStoryCell
      cell.backgroundColor = colors[indexPath.item]
      return cell
    }
    
    else if sectionType == .photo {
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ProfilePhotoCell.identifier,
        for: indexPath
      ) as! ProfilePhotoCell
      cell.backgroundColor = .red
      return cell
    }
    
    return UICollectionViewCell()
  }
  
}

