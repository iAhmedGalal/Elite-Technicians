//
//  ActivateVC.swift
//  salon
//
//  Created by AL Badr  on 6/26/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ActivateVC: UIViewController {
    
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var responseLabel: UILabel!
    
    fileprivate var presenter: ActivationPresenter?
    
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupKeyboard()
        
        presenter = ActivationPresenter(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("email", email)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.codeTF.inputAccessoryView = toolbar
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        Helper.removeKeyUserDefault(key: Constants.userDefault.userData)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loginNotification"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func activateBtn_tapped(_ sender: Any) {
        if codeTF.text == "" {
            Helper.showFloatAlert(title: "Enter activation code".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            activationCode()
        }
    }
    
    public func activationCode() {
        view.endEditing(true)
        
        let parameters = ["code": codeTF.text ?? "",
                          "email": email] as [String : Any]
        
        presenter?.checkActivationCode(parameters: parameters)
    }

}

extension ActivateVC: ActivationPresenterView {
    func getActivationSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "homeNotification"), object: nil, userInfo: nil)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getActivationFailure(_ message: String) {        
        responseLabel.text = message
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
