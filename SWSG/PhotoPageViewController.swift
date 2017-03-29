//
//  PhotoPageViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard OverviewContent.photos.count > 0 else {
            return
        }
        setUpPageViewController()
        setUpPageControl()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex + 1 < pages.count else {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex - 1 > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return OverviewContent.photos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    private func setUpPageViewController() {
        delegate = self
        dataSource = self
        
        for i in 0..<OverviewContent.photos.count {
            let pageContent = storyboard?.instantiateViewController(withIdentifier: "PhotoContentViewController") as! PhotoContentViewController
            pageContent.photoIndex = i
            pages.append(pageContent)
        }
        setViewControllers([pages[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    private func setUpPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .lightGray
        appearance.currentPageIndicatorTintColor = .black
    }
    
}
