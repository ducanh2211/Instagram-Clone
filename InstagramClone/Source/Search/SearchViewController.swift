//
//  SearchViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class SearchViewController: UIViewController {
  
  var navBar: CustomNavigationBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    title = "SearchSearchSearchSearchSearchSearchSearch"
    
    navigationItem.leftBarButtonItems = [
      .init(title: "Fuck", style: .done, target: nil, action: nil),
      .init(title: "Fuck", style: .done, target: nil, action: nil),
    ]
    
    navigationItem.rightBarButtonItems = [
      .init(title: "Cancel", style: .done, target: nil, action: nil),
      .init(title: "Done", style: .done, target: nil, action: nil),
    ]
    
//    let font = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 120))
    
//    let x = scale.applying(font)
//    let image = UIImage(systemName: "chevron.backward")!
//    let leftButton = AttributedButton(image: image, color: .red) {
//      print("Back button tap")
//    }
//
//    let rightButton = AttributedButton(title: "Done", color: .link) {
//      print("Done button tap")
//    }
//
//
//    navBar = CustomNavigationBar(title: "Search",
//                                 leftBarButtons: [leftButton],
//                                 rightBarButtons: [rightButton, .init(title: "Cancel")])
//
//    view.addSubview(navBar)
//    navBar.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      navBar.leftAnchor.constraint(equalTo: view.leftAnchor),
//      navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//      navBar.rightAnchor.constraint(equalTo: view.rightAnchor),
//      navBar.heightAnchor.constraint(equalToConstant: 44)
//    ])
  }
  
}
