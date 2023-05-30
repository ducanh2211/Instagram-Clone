//
//  UIViewController + Extension.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 16/05/2023.
//

import UIKit

extension UIViewController: PaginationableView {
    func getPaginationView() -> UIScrollView? {
        if let view = view.subviews.first(where: { $0 is UIScrollView} ) {
            return view as? UIScrollView
        } else {
            return nil
        }
    }

    func hideKeyBoardWhenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addChildController(_ child: UIViewController, toView: UIView? = nil, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        if let toView = toView {
            toView.addSubview(child.view)
        } else {
            view.addSubview(child.view)
        }

        child.didMove(toParent: self)
    }

    func removeChildController() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
