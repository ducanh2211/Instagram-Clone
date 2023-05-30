//
//  BottomSheetViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 22/05/2023.
//

import UIKit

class BottomSheetViewController: UIViewController {

    // MARK: - Properties

    private var sheetHeight: CGFloat {
        settings.sheetHeight.preferedHeight
    }

    private var spacingFromLeft: CGFloat {
        settings.type.spacingFromLeft
    }

    private var spacingFromRight: CGFloat {
        settings.type.spacingFromRight
    }

    private var spacingFromBottom: CGFloat {
        settings.type.spacingFromBottom
    }

    private var sheetCorner: BottomSheetCorner {
        settings.cornerRadius
    }

    private var sheetGrabberVisible: Bool {
        settings.grabberVisible
    }

    var rootView: UIView {
        fatalError("You have to override this property")
    }

    var settings: BottomSheetSetting {
        return BottomSheetSetting()
    }

    var dimmingView: UIView!
    var grabberView: UIView!
    var rootViewTopConstraint: NSLayoutConstraint!
    var rootViewHeightConstraint: NSLayoutConstraint!
    var originCenter: CGPoint = .zero

    // MARK: - Life cycle

    override func loadView() {
        let view = UIView()
        dimmingView = UIView()
        grabberView = UIView()

        view.addSubview(dimmingView)
        view.addSubview(rootView)
        rootView.addSubview(grabberView)
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDimmingView()
        setupRootView()
        setupGrabberView()
        setupConstraints()
    }

    // MARK: - Functions

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        let translate = gesture.translation(in: gestureView.superview).y
        let velocity = gesture.velocity(in: gestureView.superview).y
        let translatedFromOrigin = gestureView.center.y - self.originCenter.y
        let progress = translatedFromOrigin / gestureView.bounds.height

        if gesture.state == .began {
            self.originCenter = gestureView.center
        }

        else if gesture.state == .changed {
            if (velocity <= 0 && translatedFromOrigin <= 0) {
                gestureView.center.y = gestureView.center.y + translate / 20
            } else {
                gestureView.center.y = gestureView.center.y + translate
                dimmingView.alpha = 1 - progress
            }
            gesture.setTranslation(.zero, in: gestureView.superview)
        }

        else if gesture.state == .ended || gesture.state == .cancelled {
            if velocity > 1200 {
                removeSheet(duration: 0.15)
            } else if progress > 0.7 {
                removeSheet(duration: 0.15)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
                    gestureView.center = self.originCenter
                    self.dimmingView.alpha = 1
                }
            }
        }
    }

    func showSheet(duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        self.rootViewTopConstraint.constant = -(sheetHeight + spacingFromBottom)
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut]) {
            self.dimmingView.backgroundColor = .black.withAlphaComponent(0.6)
            self.view.layoutIfNeeded()
        } completion: { _ in
            completion?()
        }
    }

    func removeSheet(duration: TimeInterval = 0.25, completion: (() -> Void)? = nil) {
        self.rootViewTopConstraint.constant = 0
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut]) {
            self.dimmingView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
            completion?()
        }
    }

    @objc private func didTapDimmingView() {
        removeSheet()
    }

    // MARK: - Setup

    func setupConstraints() {
        grabberView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        rootView.translatesAutoresizingMaskIntoConstraints = false

        rootViewTopConstraint = rootView.topAnchor.constraint(equalTo: view.bottomAnchor)

        switch settings.type {
            case .fill:
                rootViewHeightConstraint = rootView.heightAnchor.constraint(equalTo: view.heightAnchor)
            case .float:
                rootViewHeightConstraint = rootView.heightAnchor.constraint(equalToConstant: sheetHeight)
        }

        NSLayoutConstraint.activate([
            grabberView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 10),
            grabberView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            grabberView.widthAnchor.constraint(equalToConstant: 36),
            grabberView.heightAnchor.constraint(equalToConstant: 4),

            dimmingView.leftAnchor.constraint(equalTo: view.leftAnchor),
            dimmingView.rightAnchor.constraint(equalTo: view.rightAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            rootView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: spacingFromLeft),
            rootView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -spacingFromRight),
            rootViewHeightConstraint,
            rootViewTopConstraint
        ])
    }

    private func setupGrabberView() {
        grabberView.backgroundColor = .systemGray2
        grabberView.layer.cornerRadius = 2
        grabberView.isHidden = !sheetGrabberVisible
    }

    private func setupDimmingView() {
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.isUserInteractionEnabled = true
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmingView)))
    }

    private func setupRootView() {
        let cornerRadius: CGFloat
        switch sheetCorner {
            case .top(let radius):
                cornerRadius = radius
                rootView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom(let radius):
                cornerRadius = radius
                rootView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .both(let radius):
                cornerRadius = radius
                rootView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,
                                                .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        rootView.layer.cornerRadius = cornerRadius
        rootView.clipsToBounds = true
        rootView.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:))))
    }
}
