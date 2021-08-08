//
//  EditProviderProfileVC.swift
//  salon
//
//  Created by AL Badr  on 6/26/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import UIKit
import DropDown

class EditProviderProfileVC: UITableViewController {
    @IBOutlet var providerTable: UITableView!
    
    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var identityImageBtn: UIButton!
    @IBOutlet weak var profileView: RoundRectView!
    @IBOutlet weak var identityView: RoundRectView!
    
    @IBOutlet weak var serialNumber: UILabel!

    @IBOutlet weak var identityTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var experienceTF: UITextField!
    
    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var areasBtn: UIButton!
    
    @IBOutlet weak var serviceCityBtn: UIButton!
    @IBOutlet weak var serviceAreaBtn: UIButton!
    @IBOutlet weak var servicesBtn: UIButton!

    @IBOutlet weak var areasCV: UICollectionView!
    @IBOutlet weak var servicesCV: UICollectionView!

    @IBOutlet weak var aboutServiceTF: UITextView!
    @IBOutlet weak var aboutProviderTF: UITextView!
    
    @IBOutlet weak var serviceImageBtn: UIButton!

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

    var imageType: String = ""
    
    var profileImageList : [UIImage] = []
    var idImageList : [UIImage] = []
    var serviceImageList : [UIImage] = []

    fileprivate var presenter: EditProfilePresenter?
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        areasCV.reloadData()
        servicesCV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginNotifications), name: NSNotification.Name(rawValue: "loginNotification"), object: nil)
                

        setupKeyboard()
        initView()
    }

    @objc func LoginNotifications(notification: NSNotification){
        Helper.ShowMainScreen(controller: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        
        if indexPath.row == 0 {
            height = 200
        }else if indexPath.row == 9 {
            height = 190
        }else if indexPath.row == 10{
            height = 90
        }else if indexPath.row == 11{
            height = 90
        }else if indexPath.row == 14{
            height = areasCellHight
        }else if indexPath.row == 16{
            height = servicesCellHight
        }else if indexPath.row == 17{
            height = 60
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
            identityTF.placeholder = "رقم الهوية أو رقم الإقامة (اختياري)"
            experienceTF.placeholder = "عدد سنوات الخبرة"
            aboutServiceTF.text = "نيذة عن الخدمات التي تقدمها"
            aboutProviderTF.text = "نبذة عن مقدم الخدمة"
        }
        
        areasCV.dataSource = self
        areasCV.delegate = self
        areasCV.register(UINib(nibName: "DistrictsCell", bundle: nil), forCellWithReuseIdentifier: "DistrictsCell")
        
        servicesCV.dataSource = self
        servicesCV.delegate = self
        servicesCV.register(UINib(nibName: "DistrictsCell", bundle: nil), forCellWithReuseIdentifier: "DistrictsCell")
        
        presenter = EditProfilePresenter(self)
        presenter?.getProviderData()
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        nameTF.inputAccessoryView = toolbar
        phoneTF.inputAccessoryView = toolbar
        emailTF.inputAccessoryView = toolbar
        identityTF.inputAccessoryView = toolbar
        experienceTF.inputAccessoryView = toolbar
        aboutServiceTF.inputAccessoryView = toolbar
        aboutProviderTF.inputAccessoryView = toolbar
        
        aboutServiceTF.delegate = self
        aboutProviderTF.delegate = self
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
                
                self.areasCellHight = 58
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
        imageType = "profile"
        showAddImageAlert()
    }
    
    @IBAction func identityBtn_tapped(_ sender: Any) {
        imageType = "id"
        showAddImageAlert()
    }
    
    @IBAction func deleteProfileBtn_tapped(_ sender: Any) {
        profileImageList.removeAll()
        profileImageBtn.setImage(#imageLiteral(resourceName: "girlgray"), for: .normal)
    }
    
    @IBAction func deleteIdentityBtn_tapped(_ sender: Any) {
        idImageList.removeAll()
        identityImageBtn.setImage(#imageLiteral(resourceName: "businessblack"), for: .normal)
    }
    
    @IBAction func serviceImageBtn_tapped(_ sender: Any) {
        imageType = "service"
        showAddImageAlert()
    }
    
    @IBAction func deleteServiceImage_tapped(_ sender: Any) {
        serviceImageList.removeAll()
        serviceImageBtn.setImage(#imageLiteral(resourceName: "imagegray"), for: .normal)
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
  
    @IBAction func changePassword_tapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: Constants.storyBoard.authentication, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        vc.title = "Change Password".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func editProviderBtn_tapped(_ sender: Any) {
        tableView.endEditing(true)
        
//        if identityTF.text == ""{
//            Helper.showFloatAlert(title: "Enter your national ID or residence number".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
//        }else{
//            if identityTF.text?.count != 10 {
//                Helper.showFloatAlert(title: "Identity number must be 10 digits".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
//            }else {
//
//            }
//        }
        
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
                            if experienceTF.text == ""{
                                Helper.showFloatAlert(title: "Enter your years of experience".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                            }else{
                                if selectedCityId == "" || selectedCityId == "0" {
                                    Helper.showFloatAlert(title: "Choose your city".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                }else {
                                    if selectedAreaId == "" || selectedAreaId == "0" {
                                        Helper.showFloatAlert(title: "Choose your area".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                    }else {
                                        if areasIDs.isEmpty {
                                            Helper.showFloatAlert(title: "Choose your wwork areas".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                                        }else {
                                            providerEdit()
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
    
    func providerEdit() {
        let player_id = "asd_zxc_qwe"//Helper.getUserDefault(key: Constants.userDefault.player_id) as! String

        let parameters = ["identity_id": identityTF.text ?? "",
                          "phone": (phoneTF.text ?? ""),
                          "city_id": selectedCityId,
                          "district_id": selectedAreaId,
                          "name": nameTF.text ?? "",
                          "experience": experienceTF.text ?? "",
                          "email": emailTF.text ?? "",
                          "player_id": player_id,
                          "cover_type": "image",
                          "lat": "0.0",
                          "lon": "0.0",
                          "place_name": aboutServiceTF.text ?? "",
                          "bio": aboutProviderTF.text ?? ""] as [String : Any]
        
        presenter?.updateProvider(parameters: parameters,
                                  profileImage: profileImageList,
                                  idImage: idImageList,
                                  serviceImage: serviceImageList,
                                  districrsIDs: areasIDs,
                                  servicesIDs: servicesIDs)
    }

}

extension EditProviderProfileVC: EditProfilePresenterView {
    func getProviderDataSuccess(_ response: LoginModel) {
        serialNumber.text = String(response.id ?? 0)
        identityTF.text = String(response.identity_id_Int ?? 0)
        nameTF.text = response.name ?? ""
        
        phoneTF.text = response.phone ?? ""
        
        emailTF.text = response.email ?? ""
        
        experienceTF.text = response.experience ?? ""
        
        aboutServiceTF.text = response.services_info ?? ""
        aboutProviderTF.text = response.bio ?? ""
        
        profileImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image ?? "")), for: .normal)
        identityImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.image_identity ?? "")), for: .normal)
        serviceImageBtn.sd_setImage(with: URL(string: SITE_URL + (response.cover ?? "")), for: .normal)
        
        selectedCityId = String(response.city_id_Int ?? 0)
        selectedServiceCityId = String(response.city_id_Int ?? 0)
        selectedAreaId = String(response.district_id_Int ?? 0)
        
        selectedAreasList = response.work_areas ?? []
        selectedServicesList = response.departments ?? []
        
        for area in selectedAreasList {
            areasIDs.append(area.id ?? 0)
        }
        
        for depart in selectedServicesList {
            servicesIDs.append(Int(depart.department_id_String ?? "0") ?? 0)
        }
        
        if selectedAreasList.isEmpty {
            areasCellHight = 0
        }else {
            areasCellHight = 58
        }
        
        if selectedServicesList.isEmpty {
            servicesCellHight = 0
        }else {
            servicesCellHight = 58
        }
        
        areasCV.reloadData()
        servicesCV.reloadData()
        
        providerTable.reloadData()
        
        presenter?.getCities()
        presenter?.getAreas(city_id: selectedCityId)
        presenter?.getServiceDepartments()
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
    
    func getClientDataSuccess(_ response: LoginModel) {}
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}


extension EditProviderProfileVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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



extension EditProviderProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        if imageType == "profile" {
            profileImageList.removeAll()
            profileImageList.append(image)
            profileImageBtn.setImage(image, for: .normal)
            
        }else if imageType == "id" {
            idImageList.removeAll()
            idImageList.append(image)
            identityImageBtn.setImage(image, for: .normal)
            
        }else if imageType == "service" {
            serviceImageList.removeAll()
            serviceImageList.append(image)
            serviceImageBtn.setImage(image, for: .normal)
        }
        
        picker.dismiss(animated: true)
    }
}

extension EditProviderProfileVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        aboutServiceTF.text = ""
        aboutServiceTF.textColor = .black
    }
}


