//
//  LoginVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class LoginVC: UITableViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var rememberBtn: UIButton!
    
    fileprivate var presenter: LoginPresenter?
    
    var isRemember: Bool = true
    var showPassword: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "splash")
        let imageViewTB = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageViewTB

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)

        if LanguageManger.shared.currentLanguage == .ar {
            emailTF.placeholder = "البريد الإلكتروني أو رقم الجوال"
            emailTF.textAlignment = .right
            
            passwordTF.placeholder = "كلمة المرور"
            passwordTF.textAlignment = .right
            
            rememberBtn.setTitle("تذكرني", for: .normal)
        }
        
        let rememberMail = Helper.getUserDefault(key: "rememberMail") as! String
        let rememberPassword = Helper.getUserDefault(key: "rememberPassword") as! String
        
        if Helper.isKeyPresentInUserDefaults(key: "rememberMail"){
            rememberBtn.setImage(#imageLiteral(resourceName: "checkselected"), for: .normal)
        }else {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkunselected"), for: .normal)
        }
        
        emailTF.text = rememberMail
        passwordTF.text = rememberPassword

        setupKeyboard()
        
        presenter = LoginPresenter(self)
    }
    
    @objc func LoginNotifications(notification: NSNotification){
        Helper.ShowMainScreen(controller: self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.emailTF.inputAccessoryView = toolbar
        self.passwordTF.inputAccessoryView = toolbar
    }
    
    @IBAction func rememberBtn_tapped(_ sender: Any) {
        if isRemember {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkunselected"), for: .normal)
            isRemember = false
        }else {
            rememberBtn.setImage(#imageLiteral(resourceName: "checkselected"), for: .normal)
            isRemember = true
        }
    }

    @IBAction func showPasswordBtn_tapped(_ sender: Any) {
        if showPassword {
            passwordTF.isSecureTextEntry = true
            showPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showPassword = false
        }else {
            passwordTF.isSecureTextEntry = false
            showPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showPassword = true
        }
    }
    
    @IBAction func forgetPassword_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ForgetPasswordVC") as! ForgetPasswordVC
        vc.title = "Forget Password".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createAccount_tapped(_ sender: Any) {
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"RegisterTypeVC") as! RegisterTypeVC
        vc.title = "Registration".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)

        if emailTF.text == "" {
            Helper.showFloatAlert(title: "Enter your email or phone number".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else{
            if passwordTF.text == "" {
                Helper.showFloatAlert(title: "Enter Password".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else{
                if isRemember {
                    Helper.saveUserDefault(key: "rememberMail", value: emailTF.text ?? "")
                    Helper.saveUserDefault(key: "rememberPassword", value: passwordTF.text ?? "")
                }else {
                    Helper.removeKeyUserDefault(key: "rememberMail")
                    Helper.removeKeyUserDefault(key: "rememberPassword")
                }
                
                login()
            }
        }
    }
    
    func login() {
        let player_id = Helper.getUserDefault(key: Constants.userDefault.player_id) as! String

        print("player_id", player_id)
        
        let parameters = ["email": emailTF.text ?? "",
                          "player_id": player_id,
                          "password": passwordTF.text ?? ""] as [String : Any]
        presenter?.Login(parameters: parameters)
    }
  
}

extension LoginVC: LoginPresenterView {
    func getLoginSuccess(_ response: LoginModel) {
        if response.block == "wait" {
            Helper.saveObjectDefault(key: Constants.userDefault.userData, value: response)
            showActivationView()

        }else if response.block == "block" {
            Helper.showFloatAlert(title: "This account is blocked".localiz(), subTitle: "", type: Constants.AlertType.AlertError)

        }else {
            Helper.saveObjectDefault(key: Constants.userDefault.userData, value: response)
            
            Helper.ShowMainScreen(controller: self)
            
            Helper.showFloatAlert(title: "Login Done Successfully".localiz(), subTitle: "", type: Constants.AlertType.AlertSuccess)
        }
    }
    
    func getLoginFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
        
        if message == "لم يتم تفعيل الحساب  " {
            showActivationView()
        }
    }

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showActivationView() {
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ActivateVC") as! ActivateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 0.5, alpha: 0.5)
        vc.email = emailTF.text ?? ""
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
