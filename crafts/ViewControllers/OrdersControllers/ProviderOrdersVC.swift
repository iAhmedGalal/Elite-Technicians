//
//  ProviderOrdersVC.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ProviderOrdersVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var providerName: String = ""
    var providerId: Int = 0
    var reservation_id: String = ""
    
    private lazy var pendingOrdersVCVC: ProviderPendingOrdersVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProviderPendingOrdersVC") as! ProviderPendingOrdersVC
        return viewController
    }()
    
    private lazy var processingOrdersVC: ProviderProcessingOrdersVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProviderProcessingOrdersVC") as! ProviderProcessingOrdersVC
        viewController.reservation_id = reservation_id
        return viewController
    }()

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "My Orders".localiz()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("Pending orders".localiz(), forSegmentAt: 0)
        segmentedControl.setTitle("Processing orders".localiz(), forSegmentAt: 1)

        add(childViewController: pendingOrdersVCVC)
    }

    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            add(childViewController: pendingOrdersVCVC)
        }else {
            add(childViewController: processingOrdersVC)
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
