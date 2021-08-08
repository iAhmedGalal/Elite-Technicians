//
//  ConfirmDueVC.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ConfirmDueVC: UIViewController {
    /*
    var reservationId: String = ""
    
    fileprivate var presenter: ConfirmDuePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        presenter = ConfirmDuePresenter(self)
    }
    
    @IBAction func cancelBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn_tapped(_ sender: Any) {
        confirmPayment()
    }
    
    func confirmPayment() {
        let parameters = ["id" : reservationId] as [String : Any]
        
        presenter?.confirmPayment(parameters: parameters)
    }
    
}

extension ConfirmDueVC: ConfirmDuePresenterView {
    func setConfirmDueSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dueNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setConfirmDueFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
 */
}

