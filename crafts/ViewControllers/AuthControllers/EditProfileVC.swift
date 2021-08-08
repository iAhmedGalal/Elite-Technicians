//
//  EditProfileVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class EditProfileVC: UITableViewController {
    
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var profileView: RoundRectView!
    
    @IBOutlet weak var serialNumber: UILabel!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!

    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var areasBtn: UIButton!
    
    fileprivate var presenter: EditProfilePresenter?
    
    var citiesList: [CitiesModel] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
    
    var areasList: [DistrictsModel] = []
    var areas:[String] = []
    let areasDropDown = DropDown()
    var selectedAreaId: String = ""
  
    var profileImageList : [UIImage] = []
    
    var token: String = ""
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "الاسم"
            phoneTF.placeholder = "الجوال"
            emailTF.placeholder = "البريد الإلكتروني"
            addressTF.placeholder = "العنوان"
        }
        
        setupKeyboard()
        
        presenter = EditProfilePresenter(self)
        presenter?.getClientData()
    }
    
    @objc func LoginNotifications(notification: NSNotification){
        Helper.ShowMainScreen(controller: self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        addressTF.inputAccessoryView = toolbar
    }
    
    func setupCitiesDropDown() {
        if let i = citiesList.firstIndex(where: { $0.city_id == Int(selectedCityId) }) {
            if LanguageManger.shared.currentLanguage == .ar {
                citiesBtn.setTitle(citiesList[i].city_name ?? "", for: .normal)
            }else {
                citiesBtn.setTitle(citiesList[i].city_name_en ?? "", for: .normal)
            }
        }else {
            citiesBtn.setTitle("Choose city".localiz(), for: .normal)
        }
        
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
        if let i = areasList.firstIndex(where: { $0.id == Int(selectedAreaId) }) {
            if LanguageManger.shared.currentLanguage == .ar {
                areasBtn.setTitle(areasList[i].name_ar ?? "", for: .normal)
            }else {
                areasBtn.setTitle(areasList[i].name_en ?? "", for: .normal)
            }
        }else {
            areasBtn.setTitle("Choose area".localiz(), for: .normal)
        }
        
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
    
    func showAddImageAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galaryImage = #imageLiteral(resourceName: "galaryblue")
        let galaryAction = UIAlertAction(title: "Photo Library".localiz(), style: .default, handler: openGalary)
        galaryAction.setValue(galaryImage, forKey: "image")
        
        let cameraImage = #imageLiteral(resourceName: "camerablue")
        let cameraAction = UIAlertAction(title: "Camera".localiz(), style: .default, handler: openCamera)
        cameraAction.setValue(cameraImage, forKey: "image")
        
        alert.addAction(galaryAction)
        alert.addAction(cameraAction)
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true)
    }
    
    @objc func openGalary(alert: UIAlertAction!) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = false
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func openCamera(alert: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.modalPresentationStyle = .fullScreen
            vc.allowsEditing = false
            vc.delegate = self
            present(vc, animated: true)
        } else {
            Helper.showFloatAlert(title: "Camera is not Available".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }
    }
    
    @IBAction func profileBtn_tapped(_ sender: Any) {
        showAddImageAlert()
    }
 
    @IBAction func deleteProfileBtn_tapped(_ sender: Any) {
        profileImageList.removeAll()
        profileImageBtn.setImage(#imageLiteral(resourceName: "girlgray"), for: .normal)
    }
 
    @IBAction func citiesBtn_tapped(_ sender: Any) {
        citiesDropDown.show()
    }
    
    @IBAction func areasBtn_tapped(_ sender: Any) {
        areasDropDown.show()
    }
    
    @IBAction func changePassword_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.title = "Change Password".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clientRegisterBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)
        
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
                                if selectedCityId == ""{
                                    Helper.showFloatAlert(title: "Choose your city".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                }else{
                                    if selectedAreaId == "" {
                                        Helper.showFloatAlert(title: "Choose your area".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                    }else {
                                        updateClientProfile()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateClientProfile() {
        let parameters = ["api_token": token,
                          "phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "district_id": selectedAreaId,
                          "name": nameTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "email": emailTF.text ?? ""] as [String : Any]
        
        presenter?.updateClient(parameters: parameters, profile: profileImageList)
    }
    
}

extension EditProfileVC: EditProfilePresenterView {
    func setServicesDepartments(_ sections: [DepartmentsModel]) {
        
    }
    
    func setServicesDepartmentsFailure() {
        
    }
    
    func getClientDataSuccess(_ response: LoginModel) {
        serialNumber.text = String(response.id ?? 0)
        nameTF.text = response.name ?? ""
        
        phoneTF.text = response.phone ?? ""
    
        emailTF.text = response.email ?? ""
        
        addressTF.text = response.address ?? ""
                
        profileImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image ?? "")), for: .normal, placeholderImage: UIImage(named: "logo"))
    
        selectedCityId = String(response.city_id ?? "")
        selectedAreaId = String(response.district_id ?? "")

        presenter?.getCities()
        presenter?.getAreas(city_id: selectedCityId)
    }
    
    func getUpdateProfileSuccess(_ response: PostModel) {
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        userDate?.name = response.name ?? ""
        userDate?.image_url = response.image_url ?? ""
        Helper.saveObjectDefault(key: Constants.userDefault.userData, value: userDate as Any)
        
        Helper.ShowMainScreen(controller: self)
        
        Helper.showFloatAlert(title: response.message ?? "", subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func getUpdateProfileFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
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
    
    func getProviderDataSuccess(_ response: LoginModel) {}

    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        profileImageList.removeAll()
        profileImageList.append(image)
        profileImageBtn.setImage(image, for: .normal)
        
        picker.dismiss(animated: true)
    }
}

