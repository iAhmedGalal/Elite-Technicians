//
//  RegisterTypeVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RegisterTypeVC: UIViewController {
    @IBOutlet weak var clientView: UIView!
    @IBOutlet weak var providerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        clientView.layer.cornerRadius = clientView.frame.height / 2
        providerView.layer.cornerRadius = providerView.frame.height / 2
    }
    
    @IBAction func clientBtn_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RegisterClientVC") as! RegisterClientVC
        vc.title = "Client Registration".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func providerBtn_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RegisterProviderVC") as! RegisterProviderVC
        vc.title = "Provider Registration".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
