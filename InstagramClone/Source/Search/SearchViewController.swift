//
//  SearchViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 14/04/2023.
//

import UIKit

class SearchViewController: UIViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    title = "Search"
    
    let vc = FakeViewController()
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    present(vc, animated: true)
  }
  
}
