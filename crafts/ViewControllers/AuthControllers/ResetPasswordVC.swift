//
//  ResetPasswordVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ResetPasswordVC: UITableViewController {
    @IBOutlet weak var resetCode: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordConfirm: UITextField!

    @IBOutlet weak var showNewPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmNewPasswordBtn: UIButton!
    
    var showNewPassword: Bool = false
    var showConfirmNewPassword: Bool = false
    
    var email: String = ""
    
    fileprivate var presenter: ResetPasswordPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            resetCode.placeholder = "الكود"
            newPassword.placeholder = "كلمة المرور الجديدة"
            newPasswordConfirm.placeholder = "تأكيد كلمة المرور الجديدة"
        }
        
        setupKeyboard()
        
        presenter = ResetPasswordPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.resetCode.inputAccessoryView = toolbar
        self.newPassword.inputAccessoryView = toolbar
        self.newPasswordConfirm.inputAccessoryView = toolbar
    }
    
    @IBAction func showNewPasswordBtn_tapped(_ sender: Any) {
        if showNewPassword {
            newPassword.isSecureTextEntry = true
            showNewPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showNewPassword = false
        }else {
            newPassword.isSecureTextEntry = false
            showNewPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showNewPassword = true
        }
    }
    
    @IBAction func showConfirmNewPasswordBtn_tapped(_ sender: Any) {
        if showConfirmNewPassword {
            newPasswordConfirm.isSecureTextEntry = true
            showConfirmNewPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showConfirmNewPassword = false
        }else {
            newPasswordConfirm.isSecureTextEntry = false
            showConfirmNewPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showConfirmNewPassword = true
        }
    }

    @IBAction func getNewPassword(_ sender: Any) {
        tableView.endEditing(true)
        
        if resetCode.text == "" {
            Helper.showFloatAlert(title: "Enter the code".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else{
            if newPassword.text == "" {
                Helper.showFloatAlert(title: "Enter new password".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                if newPassword.text != newPasswordConfirm.text  {
                    Helper.showFloatAlert(title: "Password doesn't match".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                }else {
                    ResetPassword()
                }
            }
        }
    }
    
    public func ResetPassword() {
        let parameters = ["code": resetCode.text ?? "",
                          "email": email,
                          "password": newPassword.text ?? "",
                          "password_confirmation": newPasswordConfirm.text ?? ""] as [String : Any]
        presenter?.ResetPassword(parameters: parameters)
    }

}

extension ResetPasswordVC: ResetPasswordPresenterView {
    func getNewPasswordSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        Helper.goToLoginScreen(controller: self)
    }
    
    func getNewPasswordFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

