//
//  FakeViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 20/05/2023.
//

import UIKit

protocol FakeViewControllerDelegate: AnyObject {
  func didSelectRow(with index: Int)
}

class FakeViewController: UIViewController, UITableViewDataSource,
                          UITableViewDelegate  {
  
  weak var delegate: FakeViewControllerDelegate?
  
  lazy var tableView: UITableView = {
    let tbv = UITableView()
    tbv.rowHeight = 50
    tbv.isScrollEnabled = false
    tbv.dataSource = self
    tbv.delegate = self
    tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tbv.translatesAutoresizingMaskIntoConstraints = false
    return tbv
  }()
  
  deinit {
    print("DEBUG: Fake VC deinit")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemCyan
    title = "FakeVC"
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.backgroundColor = .systemMint
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelectRow(with: indexPath.row)
    let vc = FakeViewController()
    navigationController?.pushViewController(vc, animated: true)
    
  }

  
}
