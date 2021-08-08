//
//  ContactusVC.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ContactusVC: UITableViewController {
    
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var messageBodyTF: UITextView!
    
    fileprivate var presenter: ContactsPresenter?
    
    var whatsapp : String = ""
    var twitter: String = ""
    var facebook: String = ""
    var instagram: String = ""
    var snapchat: String = ""
    
    var token: String = ""
    var name: String = ""
    var mobile: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupKeyboard()
        
        if(LanguageManger.shared.currentLanguage == .ar){
            self.nameTF.placeholder = "الاسم"
            self.nameTF.textAlignment = .right
            
            self.phoneTF.placeholder = "الجوال"
            self.phoneTF.textAlignment = .right
            
            self.emailTF.placeholder = "البريد الإلكتروني"
            self.emailTF.textAlignment = .right
            
            self.messageBodyTF.text = "الرسالة"
        }
        
        getUserData()
        
        presenter = ContactsPresenter(self)
        presenter?.GetContacts()
        
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        messageBodyTF.inputAccessoryView = toolbar
        
        messageBodyTF.delegate = self
    }
    
    func getUserData() {
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        email = userDate?.email ?? ""
        name = userDate?.name ?? ""
        mobile = userDate?.phone ?? ""
        
        nameTF.text = name
        phoneTF.text = mobile
        emailTF.text = email
        
        nameTF.isEnabled = false
        phoneTF.isEnabled = false
        emailTF.isEnabled = false
    }
    
    // MARK: - Table view data source
    @IBAction func facebookBtn_tapped(_ sender: Any) {
        Helper.openScheme(scheme: facebook)
    }
    
    @IBAction func twitterBtn_tapped(_ sender: Any) {
        Helper.openScheme(scheme: twitter)
    }
    
    @IBAction func instagramBtn_tapped(_ sender: Any) {
        Helper.openScheme(scheme: instagram)
    }
    
    @IBAction func whatsBtn_tapped(_ sender: Any) {
        Helper.openScheme(scheme: whatsapp)
    }
    
    @IBAction func snapChatBtn_tapped(_ sender: Any) {
        Helper.openScheme(scheme: snapchat)
    }
     
    @IBAction func sendMessage(_ sender: Any) {
        if token == "" {
            Helper.showFloatAlert(title: "Please, Login first", subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            if messageBodyTF.text == "" || messageBodyTF.text == "Message" || messageBodyTF.text == "الرسالة" {
                Helper.showFloatAlert(title: "Enter Message Body".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                if nameTF.text == ""{
                    Helper.showFloatAlert(title: "Enter your name".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                }else{
                    if (phoneTF.text == ""){
                        Helper.showFloatAlert(title: "Enter your phone number".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                    }else{
                        if Helper.isValidPhone(phone: phoneTF.text ?? "") == false {
                            Helper.showFloatAlert(title: "Enter a valid phone number".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                        }else {
                            if(emailTF.text == ""){
                                Helper.showFloatAlert(title: "Enter your email".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                            }else{
                                if Helper.isValidEmail(mail_address: emailTF.text ?? "") == false {
                                    Helper.showFloatAlert(title: "Enter a valid email".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                }else {
                                    ContactUS()
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    public func ContactUS(){
        let parameters = ["name": nameTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "phone": phoneTF.text ?? "",
                          "message": messageBodyTF.text ?? ""] as [String : Any]
        
        presenter?.SetContactUs(parameters: parameters)
    }
}

extension ContactusVC: ContactsPresenterView {
    func setContactsInfoSuccess(_ contacts: InfoModel) {
        mail.text = contacts.email ?? ""
        phone.text = contacts.phone ?? ""
        address.text = contacts.address ?? ""
        
        facebook = contacts.facebook ?? ""
        twitter = contacts.twitter ?? ""
        whatsapp = contacts.phone ?? ""
        instagram = contacts.instagram ?? ""
        snapchat = contacts.snap ?? ""
    }
    
    func setContactUsSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        Helper.ShowMainScreen(controller: self)
    }
    
    func setContactUsFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension ContactusVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageBodyTF.text = ""
        messageBodyTF.textColor = .black
    }
}
