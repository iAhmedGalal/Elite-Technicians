//
//  ProviderCommissionVC.swift
//  crafts
//
//  Created by AL Badr  on 1/19/21.
//

import UIKit

class ProviderCommissionVC: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var providerName: String = ""
    var providerId: Int = 0
    
    private lazy var requestDue: RequestDueVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "RequestDueVC") as! RequestDueVC
        //        viewController.provider_id = providerId
        return viewController
    }()
    
    private lazy var payDue: PayDueVC = {
        let storyboard = UIStoryboard(name: Constants.storyBoard.provider, bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "PayDueVC") as! PayDueVC
        return viewController
    }()
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Commission".localiz()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.setTitle("UnPaid".localiz(), forSegmentAt: 0)
        segmentedControl.setTitle("paid".localiz(), forSegmentAt: 1)

        add(childViewController: payDue)
    }
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        let segmentIndex = segmentedControl.selectedSegmentIndex
        
        if segmentIndex == 0 {
            add(childViewController: payDue)
        }else {
            add(childViewController: requestDue)
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
