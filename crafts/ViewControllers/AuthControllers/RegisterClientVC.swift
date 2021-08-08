//
//  RegisterClientVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class RegisterClientVC: UITableViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmTF: UITextField!
    
    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var areasBtn: UIButton!

    @IBOutlet weak var checkBtn: CheckBox!
    
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
    
    var citiesList: [CitiesModel] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
    
    var areasList: [DistrictsModel] = []
    var areas:[String] = []
    let areasDropDown = DropDown()
    var selectedAreaId: String = ""
    
    fileprivate var presenter: RegisterPresenter?
    
    var showPassword: Bool = false
    var showConfirmPassword: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "splash")
        let imageViewTB = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageViewTB

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "homeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "الاسم"
            phoneTF.placeholder = "الجوال"
            addressTF.placeholder = "العنوان"
            emailTF.placeholder = "البريد الإلكتروني"
            passwordTF.placeholder = "كلمة المرور"
            passwordConfirmTF.placeholder = "تأكيد كلمة المرور"
        }
        
        setupKeyboard()
        
        presenter = RegisterPresenter(self)
        presenter?.getCities()
    }

    @objc func LoginNotifications(notification: NSNotification){
        if notification.name.rawValue == "homeNotification" {
            Helper.ShowMainScreen(controller: self)
        }else {
            let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
            let editVC = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            editVC.title = "Login".localiz()
            self.navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        addressTF.inputAccessoryView = toolbar
        passwordTF.inputAccessoryView = toolbar
        passwordConfirmTF.inputAccessoryView = toolbar
    }
    
    func setupCitiesDropDown() {
        citiesBtn.setTitle("Choose city".localiz(), for: .normal)
        cities.removeAll()
        
        for city in citiesList{
            if LanguageManger.shared.currentLanguage == .ar {
                cities.append(city.city_name ?? "")
            }else {
                cities.append(city.city_name_en ?? "")
            }
        }
        
        citiesDropDown.anchorView = citiesBtn
        citiesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        citiesDropDown.dataSource = cities
        citiesDropDown.selectionAction = { [unowned self](index, item) in
            self.citiesBtn.setTitle(item, for: .normal)
            self.selectedCityId = "\(self.citiesList[index].city_id ?? 0)"
            self.presenter?.getAreas(city_id: self.selectedCityId)
        }
    }
    
    func setupAreasDropDown() {
        areasBtn.setTitle("Choose area".localiz(), for: .normal)
        areas.removeAll()
        
        for area in areasList{
            if LanguageManger.shared.currentLanguage == .ar {
                areas.append(area.name_ar ?? "")
            }else {
                areas.append(area.name_en ?? "")
            }
        }
        
        areasDropDown.anchorView = areasBtn
        areasDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        areasDropDown.dataSource = areas
        areasDropDown.selectionAction = { [unowned self](index, item) in
            self.areasBtn.setTitle(item, for: .normal)
            self.selectedAreaId = "\(self.areasList[index].id ?? 0)"
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
    
    @IBAction func showConfirmPasswordBtn_tapped(_ sender: Any) {
        if showConfirmPassword {
            passwordConfirmTF.isSecureTextEntry = true
            showConfirmPasswordBtn.setImage(#imageLiteral(resourceName: "eyelined"), for: .normal)
            showConfirmPassword = false
        }else {
            passwordConfirmTF.isSecureTextEntry = false
            showConfirmPasswordBtn.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
            showConfirmPassword = true
        }
    }
 
    @IBAction func citiesBtn_tapped(_ sender: Any) {
        citiesDropDown.show()
    }
    
    @IBAction func areasBtn_tapped(_ sender: Any) {
        areasDropDown.show()
    }
    
    @IBAction func termsBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
        vc.title = "Terms and conditions".localiz()
        vc.pageId = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clientRegisterBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)
 
        if checkBtn.isChecked == false {
            Helper.showFloatAlert(title: "You must agree to all terms and conditions".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            if nameTF.text == ""{
                Helper.showFloatAlert(title: "Enter your name".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else{
                if phoneTF.text == "" {
                    Helper.showFloatAlert(title: "Enter your phone number".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                }else{
                    if phoneTF.text?.prefix(2) != "05" ||  phoneTF.text?.count != 10 {
                        Helper.showFloatAlert(title: "Phone number must be 10 digits and begin with 05".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                    }else {
                        if emailTF.text == "" {
                            Helper.showFloatAlert(title: "Enter your email".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                        }else{
                            if Helper.isValidEmail(mail_address: emailTF.text ?? "") == false {
                                Helper.showFloatAlert(title: "Enter valid email".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                            }else {
                                if addressTF.text == "" {
                                    Helper.showFloatAlert(title: "Enter your address".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                }else {
                                    if selectedCityId == "" {
                                        Helper.showFloatAlert(title: "Choose your city".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                    }else {
                                        if selectedCityId == ""{
                                            Helper.showFloatAlert(title: "Choose your city".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                        }else{
                                            if selectedAreaId == "" {
                                                Helper.showFloatAlert(title: "Choose your area".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                            }else {
                                                if passwordTF.text == "" {
                                                    Helper.showFloatAlert(title: "Enter Password".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                                }else {
                                                    if passwordTF.text != passwordConfirmTF.text  {
                                                        Helper.showFloatAlert(title: "Password doesn't match".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                                    }else {
                                                        clientRegister()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func clientRegister() {
        let player_id = "asd_zxc_qwe"//Helper.getUserDefault(key: Constants.userDefault.player_id) as! String

        let parameters = ["phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "district_id": selectedAreaId,
                          "name": nameTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "password": passwordTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "password_confirmation": passwordConfirmTF.text ?? "",
                          "player_id": player_id] as [String : Any]
        
        presenter?.ClientSignup(parameters: parameters)
    }

}

extension RegisterClientVC: RegisterPresenterView {
    func getSignupSuccess(_ response: LoginModel) {
        Helper.saveObjectDefault(key: Constants.userDefault.userData, value: response)
        
        let story = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = story.instantiateViewController(withIdentifier:"ActivateVC") as! ActivateVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 0.5, alpha: 0.5)
        vc.email = emailTF.text ?? ""
        self.navigationController?.present(vc, animated: true, completion: nil)
        
        Helper.showFloatAlert(title: "Registration Done Successfully".localiz(), subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
 
    func getSignupFailure(_ message: [String]) {
        Helper.showFloatAlert(title: message[0], subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func setCities(_ sections: [CitiesModel]) {
        citiesList = sections
        setupCitiesDropDown()
    }
    
    func setCitiesFailure() {
        citiesList.removeAll()
        citiesBtn.setTitle("No Cities".localiz(), for: .normal)
    }
    
    func setAreas(_ sections: [DistrictsModel]) {
        areasList = sections
        setupAreasDropDown()
    }
    
    func setAreasFailure() {
        areasList.removeAll()
        areasBtn.setTitle("No Areas".localiz(), for: .normal)
    }
    
    func setServiceAreas(_ sections: [DistrictsModel]) {}
    
    func setServiceAreasFailure() {}
    
    func setServicesDepartments(_ sections: [DepartmentsModel]) {
  
    }
    
    func setServicesDepartmentsFailure() {

    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

