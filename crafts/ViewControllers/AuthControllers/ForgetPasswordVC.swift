//
//  ForgetPasswordVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UITableViewController {
    @IBOutlet weak var emailTF: UITextField!

    fileprivate var presenter: ForgetPasswordPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if(LanguageManger.shared.currentLanguage == .ar){
            emailTF.placeholder = "البريد الإلكتروني"
            emailTF.textAlignment = .right
        }
        
        setupKeyboard()

        presenter = ForgetPasswordPresenter(self)
    }

    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.emailTF.inputAccessoryView = toolbar
    }
    
    @IBAction func sendResetCode_tap(_ sender: Any) {
        tableView.endEditing(true)
        if emailTF.text == "" {
            Helper.showFloatAlert(title: "Enter your email".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else{
            if Helper.isValidEmail(mail_address: emailTF.text ?? "") == false {
                Helper.showFloatAlert(title: "Enter valid email".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                resetCode()
            }
        }
    }
    
    public func resetCode() {
        let parameters = ["email": emailTF.text ?? ""] as [String : Any]
        presenter?.SendResetCode(parameters: parameters)
    }
}

extension ForgetPasswordVC: ForgetPasswordPresenterView {
    func getResetPasswordSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ResetPasswordVC") as!  ResetPasswordVC
        vc.title = "Reset password".localiz()
        vc.email = emailTF.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func getResetPasswordFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
