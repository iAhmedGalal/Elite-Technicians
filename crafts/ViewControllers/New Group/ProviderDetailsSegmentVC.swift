//
//  ProviderDetailsSegmentVC.swift
//  salon
//
//  Created by AL Badr  on 6/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ProviderDetailsSegmentVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var providerName: String = ""
    var providerId: Int = 0
    
    private lazy var providerDetailsVC: ProviderDetailsVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProviderDetailsVC") as! ProviderDetailsVC
        viewController.provider_id = providerId
        return viewController
    }()
    
    private lazy var providerCommentsCV: ProviderCommentsVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "ProviderCommentsVC") as! ProviderCommentsVC
        return viewController
    }()

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = providerName
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("Details and Ratings".localiz(), forSegmentAt: 0)
        segmentedControl.setTitle("Clients Comments".localiz(), forSegmentAt: 1)

        add(childViewController: providerDetailsVC)
    }

    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            add(childViewController: providerDetailsVC)
        }else {
            add(childViewController: providerCommentsCV)
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
