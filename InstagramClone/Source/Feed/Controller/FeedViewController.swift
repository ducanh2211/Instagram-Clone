//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class FeedViewController: UIViewController {
  
  enum FeedSection: Int, CaseIterable {
    case story
    case post
  }
  
  private let viewModel: FeedViewModel
  private var collectionView: UICollectionView!
  
  // MARK: - Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    setupCollectionView()
    setupConstraints()
  }
  
  init(viewModel: FeedViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

// MARK: - UI Layout
extension FeedViewController {
  private func setupConstraints() {
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupCollectionView() {
    let layout = createLayout()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.dataSource = self
    collectionView.register(PoseCell.self, forCellWithReuseIdentifier: PoseCell.identifier)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
  }

  private func createLayout() -> UICollectionViewCompositionalLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
      switch FeedSection(rawValue: sectionIndex) {
        case .story:
          return self.createStorySection()
        case .post:
          return self.createPostSection()
        default:
          return nil
      }
    }
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.interSectionSpacing = 15
    layout.configuration = configuration
    return layout
  }
  
  private func createStorySection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(75), heightDimension: .absolute(85))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
    section.interGroupSpacing = 5
    section.orthogonalScrollingBehavior = .continuous
    return section
  }
  
  private func createPostSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 20
    return section
  }
}

// MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    FeedSection.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if FeedSection(rawValue: section) == .story {
      return 10
    } else {
      return 6
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if FeedSection(rawValue: indexPath.section) == .story {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      cell.backgroundColor = .red
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PoseCell.identifier, for: indexPath)
      return cell
    }
  }
  
}

class PoseCell: UICollectionViewCell {
  static let identifier = "PoseCell"
  let customView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(customView)
    let screen = UIScreen.main.bounds
    customView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.width)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
