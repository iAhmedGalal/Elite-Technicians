//
//  PublicReservationVC.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 21/02/2021.
//

import UIKit
import DropDown

class PublicReservationVC: UITableViewController {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var couponTF: UITextField!

    @IBOutlet weak var descriptionTF: UITextView!
    
    @IBOutlet weak var serviceImageBtn: UIButton!
    @IBOutlet weak var mainSectionBtn: UIButton!
    @IBOutlet weak var subSectionBtn: UIButton!
    @IBOutlet weak var citiesBtn: UIButton!
    @IBOutlet weak var areasBtn: UIButton!
    
    @IBOutlet weak var checkBtn: UIButton!
    
    var doneButton: UIBarButtonItem?

    var reserveDatePicker: UIDatePicker = UIDatePicker()
    var reserveTimePicker: UIDatePicker = UIDatePicker()
    
    var lon: String = "0"
    var lat: String = "0"
    var couponValue: Int = 0
    var couponId: Int = 0
    
    var reserveDateString: String = ""
    var reserveTimeString: String = ""
    
    var mainSectionsList: [DepartmentsModel] = []
    var subSectionsList: [SubDepartmentsModel] = []
    var serviceImageList: [UIImage] = []
    
    var mainSections:[String] = []
    let mainSectionsDropDown = DropDown()
    var selectedMainSectionId: String = ""
    
    var subSections:[String] = []
    let subSectionsDropDown = DropDown()
    var selectedSubSectionId: String = ""
    
    var citiesList: [CitiesModel] = []
    var cities:[String] = []
    let citiesDropDown = DropDown()
    var selectedCityId: String = ""
    
    var areasList: [DistrictsModel] = []
    var areas:[String] = []
    let areasDropDown = DropDown()
    var selectedAreaId: String = ""
    
    
    fileprivate var presenter: PublicOrderPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetLocationNotifications), name: NSNotification.Name(rawValue: "locationNotification"), object: nil)
        
        
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            nameTF.placeholder = "اسم الخدمة"
            nameTF.textAlignment = .right
            
            addressTF.placeholder = "العنوان"
            addressTF.textAlignment = .right
            
            dateTF.placeholder = "اختر التاريخ"
            dateTF.textAlignment = .right
            
            timeTF.placeholder = "اخنر الوقت"
            timeTF.textAlignment = .right
            
            couponTF.placeholder = "ادخل الكوبون"
            couponTF.textAlignment = .right
            
            descriptionTF.text = "Describe the problem in principle (Optional)".localiz()
            descriptionTF.textAlignment = .right
        }

        presenter = PublicOrderPresenter(self)
        presenter?.GetMainServices()
        presenter?.getCities()
    }
    
    @objc func GetLocationNotifications(notification: NSNotification){
        if notification.name.rawValue == "locationNotification" {
            lat = notification.userInfo?["lat"] as? String ?? ""
            lon = notification.userInfo?["lon"] as? String ?? ""
            
            addressTF.text = notification.userInfo?["placeTitle"] as? String ?? ""
            
            print("latlon", lat + "---" + lon)
        }
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.nameTF.inputAccessoryView = toolbar
        self.addressTF.inputAccessoryView = toolbar
        self.couponTF.inputAccessoryView = toolbar
        self.descriptionTF.inputAccessoryView = toolbar

        descriptionTF.delegate = self
        dateTF.delegate = self
        timeTF.delegate = self
        
        dateTF.isEnabled = false
        timeTF.isEnabled = false
    }
    
    func setupMainsDropDown() {
        mainSections.removeAll()
        
        for mainSection in mainSectionsList{
            if LanguageManger.shared.currentLanguage == .ar {
                mainSections.append(mainSection.department_name ?? "")
            }else {
                mainSections.append(mainSection.department_name_en ?? "")
            }
        }
        
        mainSectionsDropDown.anchorView = mainSectionBtn
        mainSectionsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        mainSectionsDropDown.dataSource = self.mainSections
        mainSectionsDropDown.selectionAction = { [unowned self](index, item) in
            self.mainSectionBtn.setTitle(item, for: .normal)
 
            self.selectedMainSectionId = "\(self.mainSectionsList[index].department_id ?? 0)"
            self.presenter?.GetSubServices(department_id: self.selectedMainSectionId)
        }
    }
    
    func setupSubsDropDown() {
        subSections.removeAll()
        
        for subSection in subSectionsList{
            if LanguageManger.shared.currentLanguage == .ar {
                subSections.append(subSection.name_ar ?? "")
            }else {
                subSections.append(subSection.name_en ?? "")
            }
        }
        
        subSectionsDropDown.anchorView = subSectionBtn
        subSectionsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        subSectionsDropDown.dataSource = self.subSections
        subSectionsDropDown.selectionAction = { [unowned self](index, item) in
            self.subSectionBtn.setTitle(item, for: .normal)
            
            self.selectedSubSectionId = "\(self.subSectionsList[index].id ?? 0)"
        }
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
    
    @IBAction func serviceImageBtn_tapped(_ sender: Any) {
        showAddImageAlert()
    }
    
    @IBAction func mainSectionBtn_tapped(_ sender: Any) {
        mainSectionsDropDown.show()
    }
    
    @IBAction func subSectionBtn_tapped(_ sender: Any) {
        subSectionsDropDown.show()
    }
    
    @IBAction func citiesBtn_tapped(_ sender: Any) {
        citiesDropDown.show()
    }
    
    @IBAction func areasBtn_tapped(_ sender: Any) {
        areasDropDown.show()
    }
    
    @IBAction func chooseLocationBtn_tapped(_ sender: Any) {
        view.endEditing(true)
        
        let storyBoard = UIStoryboard(name: Constants.storyBoard.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChooseLocationVC") as! ChooseLocationVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func chooseDateBtn_tapped(_ sender: Any) {
        dateTF.isEnabled = true
        pickUpDate(dateTF)
        dateTF.becomeFirstResponder()
    }
    
    @IBAction func chooseTime_tapped(_ sender: Any) {
        timeTF.isEnabled = true
        pickUpTime(timeTF)
        timeTF.becomeFirstResponder()
    }
    
    @IBAction func coupoonValueChanged(_ sender: Any) {
        view.endEditing(true)

        if couponTF.text?.count == 6 {
            let parameters = ["code": couponTF.text ?? ""] as [String:Any]
            presenter?.getCoupon(parameters: parameters)
        }
    }
    
    @IBAction func nextBtn_tapped(_ sender: Any) {
        view.endEditing(true)

        if nameTF.text == "" {
            Helper.showFloatAlert(title: "Enter service name".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if selectedMainSectionId == "" {
            Helper.showFloatAlert(title: "Choose service main section".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if selectedCityId == "" {
            Helper.showFloatAlert(title: "Choose your city".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if selectedAreaId == "" {
            Helper.showFloatAlert(title: "Choose your area".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if addressTF.text == "" {
            Helper.showFloatAlert(title: "Select your address".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if lat == "0" && lon == "0"{
            Helper.showFloatAlert(title: "Select your address".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if dateTF.text == "" {
            Helper.showFloatAlert(title: "Select reservation date".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else if timeTF.text == "" {
            Helper.showFloatAlert(title: "Select reservation time".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            
            if descriptionTF.text == "Describe the problem in principle (Optional)".localiz() {
                descriptionTF.text = ""
            }
                        
            let parameters = ["service": nameTF.text ?? "",
                              "address": addressTF.text ?? "",
                              "lat": lat,
                              "lon": lon,
                              "description": descriptionTF.text ?? "",
                              "time": reserveTimeString,
                              "date": reserveDateString,
                              "department_id": selectedMainSectionId,
                              "city_id": selectedCityId,
                              "district_id": selectedAreaId] as [String:Any]
            
            presenter?.makeReservation(parameters: parameters, dImage: serviceImageList)
        }
    }

}

extension PublicReservationVC: PublicOrderPresenterView {
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
    
    func getDepartmentsSuccess(_ response: [DepartmentsModel]) {
        mainSectionsList = response
        setupMainsDropDown()
    }
        
    func getDepartmentsFailure() {
        mainSectionsList.removeAll()
        setupMainsDropDown()
        
        subSectionBtn.setTitle("No sections found".localiz(), for: .normal)
    }
    
    func getSubDepartmentsSuccess(_ response: [SubDepartmentsModel]) {
        subSectionsList = response
        setupSubsDropDown()
    }
    
    func getSubDepartmentsFailure() {
        subSectionsList.removeAll()
        setupSubsDropDown()
        
        subSectionBtn.setTitle("No sections found".localiz(), for: .normal)
    }
    
    func getCouponSuccess(_ response: CouponModel) {
        couponId = response.coupon_id ?? 0
        checkBtn.setImage(#imageLiteral(resourceName: "checkgray"), for: .normal)
    }
    
    func getCouponFailure(_ response: String) {
        checkBtn.setImage(#imageLiteral(resourceName: "warning"), for: .normal)
    }
    
    func getReservationSuccess(_ response: ReservationResponse) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PaymentMethodsVC") as! PaymentMethodsVC
        vc.reservationId = response.reservation_id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension PublicReservationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        serviceImageList.removeAll()
        serviceImageList.append(image)
        serviceImageBtn.setImage(image, for: .normal)
        
        picker.dismiss(animated: true)
    }
}

extension PublicReservationVC: UITextFieldDelegate {
    func pickUpDate(_ textField : UITextField){
        reserveDatePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        reserveDatePicker.backgroundColor = UIColor.white
        
        if #available(iOS 13.4, *) {
            reserveDatePicker.preferredDatePickerStyle = .wheels
        }
                
        reserveDatePicker.datePickerMode = UIDatePicker.Mode.date
        reserveDatePicker.locale = Locale(identifier: "en_GB")
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 1
        
        components.calendar = calendar
        
        let minDate = calendar.date(byAdding: components, to: reserveDatePicker.date)!
        self.reserveDatePicker.minimumDate = minDate

        dateTF.inputView = reserveDatePicker
                
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done".localiz(), style: .done, target: self, action: #selector(dateSelected))
        toolbar.setItems([flexSpace, doneButton!], animated: false)
        toolbar.sizeToFit()
        
        dateTF.inputAccessoryView = toolbar
    }
    
    func pickUpTime(_ textField : UITextField){
        reserveTimePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        reserveTimePicker.backgroundColor = UIColor.white
        
        if #available(iOS 13.4, *) {
            reserveTimePicker.preferredDatePickerStyle = .wheels
        }
        
        reserveTimePicker.datePickerMode = UIDatePicker.Mode.time
        reserveTimePicker.locale = Locale(identifier: "en")
        
        timeTF.inputView = reserveTimePicker
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done".localiz(), style: .plain, target: self, action: #selector(timeSelected))
        toolbar.setItems([flexSpace, doneButton!], animated: false)
        toolbar.sizeToFit()
        
        timeTF.inputAccessoryView = toolbar
    }
    
    @objc func dateSelected(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_GB")

        reserveDateString = dateFormatter.string(from: reserveDatePicker.date)
                    
        let dateFor = DateFormatter()
        let hijriCalendar = Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        dateFor.locale = Locale.init(identifier: "en_GB") // or "ar" if you want to show arabic numbers
        dateFor.calendar = hijriCalendar
        dateFor.dateFormat = "yyyy-MM-dd"
        
        let islamicDateString = dateFor.string(from: reserveDatePicker.date)
        
        dateTF.text = reserveDateString + "   " + islamicDateString
        dateTF.resignFirstResponder()
        dateTF.isEnabled = false
    }
    
    @objc func timeSelected(){
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        timeFormatter.locale = Locale(identifier: "en")
        
        let timeAPIFormatter = DateFormatter()
        timeAPIFormatter.dateFormat = "HH:mm:ss"
        timeAPIFormatter.locale = Locale(identifier: "en")

        reserveTimeString = timeAPIFormatter.string(from: reserveTimePicker.date)
                
        timeTF.text = timeFormatter.string(from: reserveTimePicker.date)
        timeTF.resignFirstResponder()
        timeTF.isEnabled = false
    }
}

extension PublicReservationVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTF.text == "Describe the problem in principle (Optional)".localiz() {
            descriptionTF.text = ""
            descriptionTF.textColor = .black
        }
    }
}
