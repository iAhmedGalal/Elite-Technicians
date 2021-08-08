//
//  ImagesViewController.swift
//  LibyaApp
//
//  Created by AL Badr  on 8/5/18.
//  Copyright © 2018 AL Badr . All rights reserved.
//

import UIKit

class ImagesViewController: UIPageViewController, UIPageViewControllerDataSource {
    
//    var arrImagesList: [UIImage] = []
    var arrImagesList: [String] = []
    var imagInx: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: imagInx)] as [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        //        pageContentViewController.image = arrImagesList[index]
        pageContentViewController.imageURL = "\(arrImagesList[index])"
        pageContentViewController.imageIndex = index

        return pageContentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("Page Before")
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        
        var index = pageContent.imageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1
        if (index == arrImagesList.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("Page After")

        let pageContent: PageContentViewController = viewController as! PageContentViewController
        
        var index = pageContent.imageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1
        if (index == arrImagesList.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
        
    }
    
}
