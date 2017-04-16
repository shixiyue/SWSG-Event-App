//
//  PhotoPageViewController.swift
//  SWSG
//
//  Created by Shi Xiyue on 25/3/17.
//  Copyright © 2017 nus.cs3217.swsg. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIPageViewController {
    
    var images: [UIImage]!
    
    fileprivate var pages: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard images.count > 0 else {
            return
        }
        setUpPageViewController()
    }
    
    func setUpPageViewController() {
        guard images.count > 0 else {
            return
        }
        delegate = self
        dataSource = self
        
        setUpPages()
        setUpPageControl()
    }
    
    private func setUpPages() {
        pages = []
        for image in images {
            guard let pageContent = storyboard?.instantiateViewController(withIdentifier: Config.photoContentViewController) as? PhotoContentViewController else {
                continue
            }
            pageContent.setImage(image)
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

extension PhotoPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex + 1 < pages.count else {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.index(of: viewController), currentIndex - 1 >= 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    } 
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
