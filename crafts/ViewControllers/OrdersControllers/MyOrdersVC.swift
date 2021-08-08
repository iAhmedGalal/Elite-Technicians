//
//  MyOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MyOrdersVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var providerName: String = ""
    var providerId: Int = 0
    var reservation_id: String = ""
    
    private lazy var currentOrdersVCVC: CurrentOrdersVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrentOrdersVC") as! CurrentOrdersVC
        viewController.provider_id = providerId
        viewController.reservation_id = reservation_id
        return viewController
    }()
    
    private lazy var previousOrdersVC: PreviousOrdersVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.user, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PreviousOrdersVC") as! PreviousOrdersVC
        return viewController
    }()

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "My Orders".localiz()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("Waiting orders".localiz(), forSegmentAt: 0)
        segmentedControl.setTitle("Wating accept orders".localiz(), forSegmentAt: 1)

        add(childViewController: currentOrdersVCVC)
    }

    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            add(childViewController: currentOrdersVCVC)
        }else {
            add(childViewController: previousOrdersVC)
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
