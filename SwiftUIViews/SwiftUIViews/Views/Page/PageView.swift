//
//  PageView.swift
//  SwiftUIViews
//
//  Created by ChanWook on 5/16/24.
//

import SwiftUI
import UIKit

struct PageView: UIViewControllerRepresentable {
    var viewControllers: [UIViewController]
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    func updateUIViewController(
        _ pageViewController: UIPageViewController,
        context: Context
    ) {
        guard 
            let nextViewController = viewControllers[safe: currentPage],
            pageViewController.currentViewController != nextViewController
        else { return }
        
        pageViewController.setViewControllers(
            [nextViewController],
            direction: pageNavigationDirection(pageViewController),
            animated: true
        )
    }
    
    private func pageNavigationDirection(
        _ pageViewController: UIPageViewController
    ) -> UIPageViewController.NavigationDirection {
        var direction: UIPageViewController.NavigationDirection = .forward
        
        if let currentViewController = pageViewController.currentViewController,
           let index = viewControllers.firstIndex(of: currentViewController),
           index > currentPage {
            direction = .reverse
        }
        
        return direction
    }

    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageView

        init(_ pageViewController: PageView) {
            parent = pageViewController
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController)
            else { return nil }
            let previousIndex = index - 1
            return previousIndex < 0 ? nil : parent.viewControllers[previousIndex]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let index = parent.viewControllers.firstIndex(of: viewController)
            else { return nil }
            let nextIndex = index + 1
            return nextIndex == parent.viewControllers.count
            ? nil
            : parent.viewControllers[nextIndex]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            guard
                completed,
                let viewController = pageViewController.viewControllers?.first,
                let index = parent.viewControllers.firstIndex(of: viewController)
            else { return }
            parent.currentPage = index
        }
    }
}

#Preview {
    let viewControllers = [SampleList(title: "first"), SampleList(title: "second")]
        .map { UIHostingController(rootView: $0) }
    @State var currentPage = 0
    
    return PageView(viewControllers: viewControllers, currentPage: $currentPage)
}

private extension UIPageViewController {
    var currentViewController: UIViewController? {
        viewControllers?.first
    }
}
