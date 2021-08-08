//
//  RegisterProviderVC.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class RegisterProviderVC: UITableViewController {
    @IBOutlet var providerTable: UITableView!

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var experienceTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfirmTF: UITextField!
    
    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var areasBtn: UIButton!

    @IBOutlet weak var checkBtn: CheckBox!
    
    @IBOutlet weak var showPasswordBtn: UIButton!
    @IBOutlet weak var showConfirmPasswordBtn: UIButton!
 
    @IBOutlet weak var serviceCityBtn: UIButton!
    @IBOutlet weak var serviceAreaBtn: UIButton!
    @IBOutlet weak var servicesBtn: UIButton!

    @IBOutlet weak var areasCV: UICollectionView!
    @IBOutlet weak var servicesCV: UICollectionView!

    var selectedAreasList: [DistrictsModel] = []
    var selectedServicesList: [DepartmentsModel] = []

    var citiesList: [CitiesModel] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
 
    let serviceCitiesDropDown = DropDown()
    var selectedServiceCityId: String = ""
    
    var areasList: [DistrictsModel] = []
    var areas:[String] = []
    let areasDropDown = DropDown()
    var selectedAreaId: String = ""
    
    var serviceAreasList: [DistrictsModel] = []
    var serviceAreas:[String] = []
    let serviceAreasDropDown = DropDown()
    var selectedServiceAreaId: String = ""
    
    var departmentsList: [DepartmentsModel] = []
    var departments:[String] = []
    let departmentsDropDown = DropDown()
    var selectedDepartmentId: String = ""
    
    var areasIDs: [Int] = []
    var servicesIDs: [Int] = []

    var areasCellHight: CGFloat = 0
    var servicesCellHight: CGFloat = 0

    fileprivate var presenter: RegisterPresenter?
    
    var showPassword: Bool = false
    var showConfirmPassword: Bool = false
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        areasCV.reloadData()
        servicesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "splash")
        let imageViewTB = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageViewTB
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "homeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)

                

        setupKeyboard()
        initView()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 9{
            height = areasCellHight
        }else if indexPath.row == 11{
            height = servicesCellHight
        }else if indexPath.row == 14{
            height = 70
        }else if indexPath.row == 15{
            height = 80
        }else {
            height = 55
        }
        
        return height
    }
    
    func initView() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "الاسم"
            phoneTF.placeholder = "الجوال"
            emailTF.placeholder = "البريد الإلكتروني"
            addressTF.placeholder = "العنوان"
            experienceTF.placeholder = "عدد سنوات الخبرة"
            passwordTF.placeholder = "كلمة المرور"
            passwordConfirmTF.placeholder = "تأكيد كلمة المرور"
        }
        
        areasCV.dataSource = self
        areasCV.delegate = self
        areasCV.register(UINib(nibName: "DistrictsCell", bundle: nil), forCellWithReuseIdentifier: "DistrictsCell")
  
        
        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "DistrictsCell", bundle: nil), forCellWithReuseIdentifier: "DistrictsCell")
        
        
        
        presenter = RegisterPresenter(self)
        presenter?.getCities()
        presenter?.getServiceDepartments()
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        experienceTF.inputAccessoryView = toolbar
        passwordTF.inputAccessoryView = toolbar
        passwordConfirmTF.inputAccessoryView = toolbar
    }
    
    func setupCitiesDropDown() {
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
    
    func setupServiceCitiesDropDown() {
        cities.removeAll()
        
        for city in citiesList{
            if LanguageManger.shared.currentLanguage == .ar {
                cities.append(city.city_name ?? "")
            }else {
                cities.append(city.city_name_en ?? "")
            }
        }

        serviceCitiesDropDown.anchorView = serviceCityBtn
        serviceCitiesDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        serviceCitiesDropDown.dataSource = cities
        serviceCitiesDropDown.selectionAction = { [unowned self](index, item) in
            self.serviceCityBtn.setTitle(item, for: .normal)
            self.selectedServiceCityId = "\(self.citiesList[index].city_id ?? 0)"
            self.presenter?.getServiceAreas(city_id: self.selectedServiceCityId)
        }
    }
    
    func setupServiceAreasDropDown() {
        serviceAreas.removeAll()
        
        for area in serviceAreasList {
            if LanguageManger.shared.currentLanguage == .ar {
                serviceAreas.append(area.name_ar ?? "")
            }else {
                serviceAreas.append(area.name_en ?? "")
            }
        }
        
        serviceAreasDropDown.anchorView = serviceAreaBtn
        serviceAreasDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        serviceAreasDropDown.dataSource = serviceAreas
        serviceAreasDropDown.selectionAction = { [unowned self](index, item) in
            self.serviceAreaBtn.setTitle(item, for: .normal)

            self.selectedServiceAreaId = "\(self.serviceAreasList[index].id ?? 0)"
            
            if self.areasIDs.contains(Int(self.selectedServiceAreaId) ?? 0) {
                Helper.showFloatAlert(title: "You have already added the area".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                self.areasIDs.append(self.serviceAreasList[index].id ?? 0)
                
                var areaData = DistrictsModel()
                areaData.id = self.serviceAreasList[index].id ?? 0
                
                if LanguageManger.shared.currentLanguage == .ar {
                    areaData.name_ar = item
                }else {
                    areaData.name_en = item
                }
                
                self.selectedAreasList.append(areaData)
                self.areasCV.reloadData()
                
                self.areasCellHight = 60
                self.providerTable.reloadData()
            }
        }
    }
    
    func setupDepartmentsDropDown() {
        departments.removeAll()
        
        for depart in departmentsList {
            if LanguageManger.shared.currentLanguage == .ar {
                departments.append(depart.department_name ?? "")
            }else {
                departments.append(depart.department_name_en ?? "")
            }
        }
        
        departmentsDropDown.anchorView = servicesBtn
        departmentsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        departmentsDropDown.dataSource = departments
        departmentsDropDown.selectionAction = { [unowned self](index, item) in
            self.servicesBtn.setTitle(item, for: .normal)
            
            self.selectedDepartmentId = "\(self.departmentsList[index].department_id ?? 0)"
            
            if self.servicesIDs.contains(Int(self.selectedDepartmentId) ?? 0) {
                Helper.showFloatAlert(title: "You have already added the service".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                self.servicesIDs.append(self.departmentsList[index].department_id ?? 0)
                
                let departmentData = DepartmentsModel()
                departmentData.department_id = self.departmentsList[index].department_id ?? 0
                
                if LanguageManger.shared.currentLanguage == .ar {
                    departmentData.department_name = item
                }else {
                    departmentData.department_name_en = item
                }
                
                self.selectedServicesList.append(departmentData)
                self.servicesCV.reloadData()
                
                self.servicesCellHight = 60
                self.providerTable.reloadData()
            }
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
    
    @IBAction func serviceCitiesBtn_tapped(_ sender: Any) {
        serviceCitiesDropDown.show()
    }
    
    @IBAction func servicesAreasBtn_tapped(_ sender: Any) {
        serviceAreasDropDown.show()
    }
    
    @IBAction func servicesBtn_tapped(_ sender: Any) {
        departmentsDropDown.show()
    }
    
    @IBAction func termsBtn_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PagesDetailsVC") as! PagesDetailsVC
        vc.title = "Terms and conditions".localiz()
        vc.pageId = 2
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func providerRegisterBtn_tapped(_ sender: Any) {
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
                                        if selectedAreaId == "" {
                                            Helper.showFloatAlert(title: "Choose your area".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                        }else {
                                            if areasIDs.isEmpty {
                                                Helper.showFloatAlert(title: "Choose your service areas".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                            }else {
                                                if passwordTF.text == "" {
                                                    Helper.showFloatAlert(title: "Enter Password".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                                }else {
                                                    if passwordTF.text != passwordConfirmTF.text  {
                                                        Helper.showFloatAlert(title: "Password doesn't match".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                                    }else {
                                                        providerRegister()
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
    
    func providerRegister() {
        let player_id = "asd_zxc_qwe"//Helper.getUserDefault(key: Constants.userDefault.player_id) as! String
        
        let parameters = ["phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "district_id": selectedAreaId,
                          "name": nameTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "address": addressTF.text ?? "",
                          "experience": experienceTF.text ?? "",
                          "password": passwordTF.text ?? "",
                          "password_confirmation": passwordConfirmTF.text ?? "",
                          "player_id": player_id,
                          "items": servicesIDs,
                          "districts": areasIDs] as [String : Any]

        presenter?.ProviderSignup(parameters: parameters)
    }

}

extension RegisterProviderVC: RegisterPresenterView {
    func getSignupSuccess(_ response: LoginModel) {
        Helper.saveObjectDefault(key: Constants.userDefault.userData, value: response)
        
        Helper.goToLoginScreen(controller: self)
        
        Helper.showFloatAlert(title: "Registration Done Successfully. Pending Management Approval".localiz(), subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
 
    func getSignupFailure(_ message: [String]) {
        Helper.showFloatAlert(title: message[0], subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func setCities(_ sections: [CitiesModel]) {
        citiesList = sections
        setupCitiesDropDown()
        setupServiceCitiesDropDown()
    }
    
    func setCitiesFailure() {
        citiesList.removeAll()
        citiesBtn.setTitle("No Cities".localiz(), for: .normal)
        setupCitiesDropDown()
        setupServiceCitiesDropDown()
    }
    
    func setAreas(_ sections: [DistrictsModel]) {
        areasList = sections
        setupAreasDropDown()
    }
    
    func setAreasFailure() {
        areasList.removeAll()
        areasBtn.setTitle("No Areas".localiz(), for: .normal)
        setupAreasDropDown()
    }
    
    func setServiceAreas(_ sections: [DistrictsModel]) {
        serviceAreasList = sections
        setupServiceAreasDropDown()
    }
    
    func setServiceAreasFailure() {
        serviceAreasList.removeAll()
        serviceAreaBtn.setTitle("No Areas".localiz(), for: .normal)
        setupServiceAreasDropDown()
    }
    
    func setServicesDepartments(_ sections: [DepartmentsModel]) {
        departmentsList = sections
        setupDepartmentsDropDown()
    }
    
    func setServicesDepartmentsFailure() {
        departmentsList.removeAll()
        servicesBtn.setTitle("No Services".localiz(), for: .normal)
        setupDepartmentsDropDown()
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}


extension RegisterProviderVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case servicesCV:
            if LanguageManger.shared.currentLanguage == .ar {
                let text = selectedServicesList[indexPath.row].department_name ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }else {
                let text = selectedServicesList[indexPath.row].department_name_en ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }
            
        default:
            if LanguageManger.shared.currentLanguage == .ar {
                let text = selectedAreasList[indexPath.row].name_ar ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }else {
                let text = selectedAreasList[indexPath.row].name_en ?? ""
                let cellWidth = text.size(withAttributes:[.font: UIFont.systemFont(ofSize:16.0)]).width + 72
                return CGSize(width: cellWidth, height: 45)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case servicesCV:
            return selectedServicesList.count
        default:
            return selectedAreasList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case servicesCV:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictsCell", for: indexPath) as?
                DistrictsCell else {
                    return UICollectionViewCell()
            }
            
            cell.configDepartmentsCell(item: selectedServicesList[indexPath.row])
            
            cell.deleteBtn.addTarget(self, action: #selector(deleteService_tapped(_:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            
            return cell
            
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictsCell", for: indexPath) as?
                DistrictsCell else {
                    return UICollectionViewCell()
            }
            
            cell.configDistrictsCell(item: selectedAreasList[indexPath.row])
                        
            cell.deleteBtn.addTarget(self, action: #selector(deleteAreas_tapped), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            
            return cell
        }
        
    }
    
    @objc func deleteService_tapped(_ sender: UIButton) {
        selectedServicesList.remove(at: sender.tag)
        servicesIDs.remove(at: sender.tag)
        
        servicesCV.reloadData()
        
        if selectedServicesList.isEmpty {
            servicesCellHight = 0
            providerTable.reloadData()
        }
    }
    
    @objc func deleteAreas_tapped(_ sender: UIButton) {
        selectedAreasList.remove(at: sender.tag)
        areasIDs.remove(at: sender.tag)
        
        areasCV.reloadData()
        
        if selectedAreasList.isEmpty {
            areasCellHight = 0
            providerTable.reloadData()
        }
    }
}

