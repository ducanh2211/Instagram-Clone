//
//  ContainerScrollViewController.swift
//  InstagramClone
//
//  Created by Đức Anh Trần on 10/05/2023.
//

import UIKit

class ContainerScrollViewController: UIViewController {

    // MARK: - Property

    private var headerView: UIView {
        headerVC.view
    }

    private var bottomView: UIView {
        bottomVC.view
    }

    private var menuItemHeight: CGFloat {
        bottomVC.menuItemHeight
    }

    private var headerHeight: CGFloat {
        bottomView.frame.minY
    }

    /// Height tối thiểu của `headerView` nơi mà nó sẽ dính vào top screen. Khi đó
    /// `containerScrollView` sẽ dừng scroll và`panView` sẽ được scroll.
    private var minHeaderHeight: CGFloat {
        dataSource.minHeaderViewHeight
    }

    /// Dùng để track index hiện tại của panView đang được hiển thị trên màn hình.
    private var currentIndex: Int = 0

    /// Dùng để track content offset cho từng pagination view.
    private var currentContentOffsets: [Int: CGFloat] = [:]

    /// Dùng để lưu lại toàn bộ pagination views (về cơ bản thì đây sẽ là các scroll view thuộc các page controller của `bottomVC`)
    private var panViews: [Int: UIScrollView] = [:] {
        didSet { configurePanView() }
    }

    /// Là scroll view dùng để chứa subviews `headerView` và `bottomView`.
    private var containerSrollView: UIScrollView!
    private var contentView: UIView!

    /// Là scroll view sẽ thực sự được scroll,
    /// nó sẽ tính toán offset để cho phép `containerSrollView` hoặc `panViews` được phép scroll.
    private var logicHandlerScrollView: UIScrollView!

    /// Phần header view controller.
    private var headerVC: UIViewController!

    /// Phần bottom view controller dùng để quản lý của paging view controllers.
    /// Có thể sử dụng đến thư viện thứ ba như: `Parchment`, `XLPagerTabStrip`.
    private var bottomVC: BottomControllerProvider!

    weak var dataSource: ContainerScrollViewDatasource!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLogicHandlerScrollView()
        setupContainerScrollView()
        setupHeaderVC()
        setupBottomVC()
    }

    deinit {
        panViews.forEach { (_, scrollView) in
            scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), context: nil)
        }
    }

    // MARK: - Functions

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {

//        if let object = object as? UIScrollView, let panView = panViews[currentIndex], object == panView {
//            if let contentSize = change?[.newKey] as? CGSize, keyPath == #keyPath(UIScrollView.contentSize) {
//                let height = max(
//                    contentSize.height + headerHeight + menuItemHeight, // Trường hợp content height > view.bounds.height
//                    view.frame.height + headerHeight - minHeaderHeight  // Trường hợp content height < view.bounds.height
//                )
//                logicHandlerScrollView.contentSize = CGSize(width: contentSize.width, height: height)
//                print("DEBUG: \(logicHandlerScrollView.contentSize)")
//            }
//        }

        if let object = object as? UIScrollView, keyPath == #keyPath(UIScrollView.contentSize) {
            if let panView = panViews[currentIndex], object == panView  {
                updateLogicHanlderScrollContentSize(with: panView)
            }
        }
    }

    /// Update lại content size của `logicHandlerScrollView`.
    private func updateLogicHanlderScrollContentSize(with scrollView: UIScrollView) {
        logicHandlerScrollView.contentSize = getContentSize(for: scrollView)
        print("DEBUG: size \(getContentSize(for: scrollView))")
    }

    /// Tính toán lại content size.
    private func getContentSize(for scrollView: UIScrollView) -> CGSize {
        let height = max(
            scrollView.contentSize.height + headerHeight + menuItemHeight, // Trường hợp content height > view.bounds.height
            view.frame.height + headerHeight - minHeaderHeight             // Trường hợp content height < view.bounds.height
        )
        return CGSize(width: scrollView.contentSize.width, height: height)
    }

    /// Configure mỗi `panView` trước khi được được add vào dictionary `panViews`.
    private func configurePanView() {
        if let scrollView = panViews[currentIndex] {
            //`currentGestureRecognizer.require(toFail otherGestureRecognizer:)`: là method dùng
            // để bắt buộc `currentGestureRecognizer` đợi cho đến khi `otherGestureRecognizer`
            // chuyển sang `UIGestureRecognizer.State.fail` thì nó mới có thể được kích hoạt. Trong trường hợp này,
            // `panView` chỉ được phép scroll "khi và chỉ khi" panGestureRecognizer của`logicHandlerScrollView` return `fail`.
            scrollView.panGestureRecognizer.require(toFail: logicHandlerScrollView.panGestureRecognizer)
            scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ContainerScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        currentContentOffsets[currentIndex] = currentOffset

        // Khoảng cách xa nhất mà `overlayScrollView` cho phép `containerScrollView` được scroll
        // trước khi header bị dính vào top screen, và `panView` sau đó sẽ được scroll.
        let maximumScrollDistance = headerHeight - minHeaderHeight

        if currentOffset < maximumScrollDistance {
            containerSrollView.contentOffset.y = currentOffset
            panViews.forEach { (_, scrollView) in
                scrollView.contentOffset.y = 0
            }
            currentContentOffsets.removeAll()
        }
        else {
            containerSrollView.contentOffset.y = maximumScrollDistance
            let targetOffset = currentOffset - maximumScrollDistance
            if let panView = panViews[currentIndex] {
                panView.contentOffset.y = targetOffset
            }
        }
    }
}

// MARK: - DABottomDelegate

extension ContainerScrollViewController: BottomControllerProviderDelegate {
    func bottomControllerProvider(_ bottomControllerProvider: BottomControllerProvider,
                                  currentViewController: UIViewController, currentIndex: Int) {
        self.currentIndex = currentIndex

        // Nếu `currentContentOffsets[currentIndex]` == `nil` thì chỉ có 2 trường hợp:
        // 1. `containerScrollView` đã được phép scroll dẫn đến header không còn dính vào top screen nữa.
        // Khi đó, `currentContentOffsets.removeAll()` sẽ được gọi trên `scrollViewDidScroll`.
        // 2. `panViews[currentIndex]` == `nil` (i.e. chưa được add).
        if let contentOffset = currentContentOffsets[currentIndex] {
            logicHandlerScrollView.contentOffset.y = contentOffset
        } else {
            logicHandlerScrollView.contentOffset.y = containerSrollView.contentOffset.y
        }

        if let panView = currentViewController.getPaginationView(), panViews[currentIndex] == nil {
            panViews[currentIndex] = panView
        }

        // Update lại `contentSize` của `logicHandlerScrollView` với `panView` (i.e. scrollView).
        // Xảy ra lỗi nếu không có dòng code này: khi chuyển từ `panView` có contentSize nhỏ hơn sang `panView`
        // có contentSize lớn hơn sẽ làm cho `panView` lớn hơn không thể scroll được. Vì vậy cần update contentSize. */
        if let panView = panViews[currentIndex] {
            updateLogicHanlderScrollContentSize(with: panView)
        }
    }
}

// MARK: - Setup

extension ContainerScrollViewController {
    private func setupLogicHandlerScrollView() {
        logicHandlerScrollView = UIScrollView()
        view.addSubview(logicHandlerScrollView)
        logicHandlerScrollView.pinToView(view)

        logicHandlerScrollView.delegate = self
        logicHandlerScrollView.showsVerticalScrollIndicator = false
        logicHandlerScrollView.showsHorizontalScrollIndicator = false
        logicHandlerScrollView.layer.zPosition = CGFloat.greatestFiniteMagnitude // Dòng này vẫn chưa hiểu chức năng.
        logicHandlerScrollView.contentInsetAdjustmentBehavior = .never
    }

    private func setupContainerScrollView() {
        contentView = UIView()
        containerSrollView = UIScrollView()
        containerSrollView.addSubview(contentView)
        view.addSubview(containerSrollView)
        containerSrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let contentGuide = containerSrollView.contentLayoutGuide
        let frameGuide = containerSrollView.frameLayoutGuide

        NSLayoutConstraint.activate([
            containerSrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerSrollView.topAnchor.constraint(equalTo: view.topAnchor),
            containerSrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerSrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leftAnchor.constraint(equalTo: contentGuide.leftAnchor),
            contentView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            contentView.rightAnchor.constraint(equalTo: contentGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
        ])

        containerSrollView.showsVerticalScrollIndicator = false
        containerSrollView.showsHorizontalScrollIndicator = false
        //    containerSrollView.removeGestureRecognizer(containerSrollView.panGestureRecognizer)
        containerSrollView.addGestureRecognizer(logicHandlerScrollView.panGestureRecognizer)
        containerSrollView.contentInsetAdjustmentBehavior = .never
    }

    private func setupHeaderVC() {
        headerVC = dataSource.headerViewController
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addChildController(headerVC, toView: contentView)

        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }

    private func setupBottomVC() {
        bottomVC = dataSource.bottomViewController
        bottomVC.delegate = self
        addChildController(bottomVC, toView: contentView)

        let frameGuide = containerSrollView.frameLayoutGuide
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bottomView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: frameGuide.heightAnchor)
        ])

        let controller = bottomVC.currentViewController
        panViews[currentIndex] = controller.getPaginationView()
    }
}
