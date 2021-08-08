//
//  EditVC.swift
//  salon
//
//  Created by AL Badr  on 7/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class EditVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var providerName: String = ""
    var providerId: Int = 0
    var type: String = ""
    var fromNotifications: Bool = false
    
    private let editClientVC: EditProfileVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        return viewController
    }()
    
    private let editProviderVC: EditProviderProfileVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "EditProviderProfileVC") as! EditProviderProfileVC
        return viewController
    }()
    
    private let commentsVC: ProfileCommentsVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProfileCommentsVC") as! ProfileCommentsVC
        return viewController
    }()

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("My info".localiz(), forSegmentAt: 0)

        if type == "provider" {
            segmentedControl.setTitle("Clients comments".localiz(), forSegmentAt: 1)
            
            if fromNotifications {
                add(childViewController: commentsVC)
                segmentedControl.selectedSegmentIndex = 1
            }else {
                add(childViewController: editProviderVC)
                segmentedControl.selectedSegmentIndex = 0
            }
            
        }else {
            segmentedControl.setTitle("Providers comments".localiz(), forSegmentAt: 1)
            
            if fromNotifications {
                add(childViewController: commentsVC)
                segmentedControl.selectedSegmentIndex = 1
            }else {
                add(childViewController: editClientVC)
                segmentedControl.selectedSegmentIndex = 0
            }
        }
        
    }

    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            if type == "provider" {
                add(childViewController: editProviderVC)
            }else {
                add(childViewController: editClientVC)
            }
        }else {
            add(childViewController: commentsVC)
        }
    }
    
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        childViewController.view.frame = contentView.bounds
        contentView.addSubview(childViewController.view)
    }
    
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
}
