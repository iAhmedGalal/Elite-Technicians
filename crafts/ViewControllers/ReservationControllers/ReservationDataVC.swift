//
//  ReservationDataVC.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class ReservationDataVC: UIViewController {
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var timeTF: UITextField!

    @IBOutlet weak var totalServiceLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var totalAfterVatLabel: UILabel!
        
    @IBOutlet weak var totalServiceView: UIStackView!
    @IBOutlet weak var vatView: UIStackView!
    @IBOutlet weak var totalAfterVatView: UIStackView!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalAfterDiscountLabel: UILabel!
        
    @IBOutlet weak var discountView: RoundRectView!
    
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var couponTF: UITextField!
    @IBOutlet weak var couponResponseLabel: UILabel!
    
    var doneButton: UIBarButtonItem?

    var reserveDatePicker: UIDatePicker = UIDatePicker()
    var reserveTimePicker: UIDatePicker = UIDatePicker()
    
    var lon: String = "0"
    var lat: String = "0"
    
    var reserveDateString: String = ""
    var reserveTimeString: String = ""
    
    var valueAdded: String = ""
    var couponValue: Int = 0
    var couponId: Int = 0
    var totalPrice: Double = 0
    var finalPrice: Double = 0
    var providerId: Int = 0
    var service_ids: [Int] = []
    
    var discountPercentage: String = ""
    
    var reservationData: ReservationModel?
    
    fileprivate var presenter: DateLocationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GetLocationNotifications), name: NSNotification.Name(rawValue: "locationNotification"), object: nil)
        
        reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        
        service_ids = reservationData?.service_ids ?? []
                
        setupKeyboard()
        getSettings()
        
        if LanguageManger.shared.currentLanguage == .ar {
            addressTF.placeholder = "العنوان"
            addressTF.textAlignment = .right
            
            dateTF.placeholder = "اختر التاريخ"
            dateTF.textAlignment = .right
            
            timeTF.placeholder = "اخنر الوقت"
            timeTF.textAlignment = .right
            
            couponTF.placeholder = "ادخل الكوبون"
            couponTF.textAlignment = .right
        }
        
        presenter = DateLocationPresenter(self)
        
        discountView.isHidden = true
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
        self.addressTF.inputAccessoryView = toolbar
        self.couponTF.inputAccessoryView = toolbar

        dateTF.delegate = self
        timeTF.delegate = self
        
        dateTF.isEnabled = false
        timeTF.isEnabled = false
    }

    func getSettings() {
        let userSettings = Helper.getObjectDefault(key: Constants.userDefault.userSettings) as? SettingsModel
        valueAdded = userSettings?.value_added ?? "0"
        
        if valueAdded == "0" {
            vatView.isHidden = true
            totalAfterVatView.isHidden = true
            
            finalPrice = totalPrice
            
        }else {
            vatView.isHidden = false
            totalAfterVatView.isHidden = false
            
            vatLabel.text = (valueAdded) + "%"
            
            let priceAdded = (totalPrice / 100) * (Double(valueAdded) ?? 0)
            
            vatLabel.text = (valueAdded) + "%" + " = " + "\(priceAdded)" + " " + ("SAR".localiz())
            
            finalPrice = totalPrice + priceAdded
            totalAfterVatLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
        }
        
        totalServiceLabel.text = "\(totalPrice)" + " " + ("SAR".localiz())
        totalLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
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

        if lat == "0" && lon == "0"{
            Helper.showFloatAlert(title: "Select your address".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            if dateTF.text == "" {
                Helper.showFloatAlert(title: "Select reservation date".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                if timeTF.text == "" {
                    Helper.showFloatAlert(title: "Select reservation time".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
                }else {

                    let parameters = ["provider_id": providerId,
                                      "address": addressTF.text ?? "",
                                      "lat": lat,
                                      "lon": lon,
                                      "comment": "Comment",
                                      "time": reserveTimeString,
                                      "date": reserveDateString,
                                      "coupon_id": couponId,
                                      "coupon_percentage": couponValue,
                                      "service_ids": service_ids] as [String:Any]
                    
                    presenter?.makeReservation(parameters: parameters)
                }
            }
        }
    }
}

extension ReservationDataVC: DateLocationPresenterView {
    func getCouponSuccess(_ response: CouponModel) {
        couponId = response.coupon_id ?? 0
        
        discountView.isHidden = false

        checkBtn.setImage(#imageLiteral(resourceName: "checkgray"), for: .normal)

        couponValue = response.discount ?? 0
               
        let priceDiscount = (totalPrice / 100) * (Double(couponValue))
        finalPrice = totalPrice - priceDiscount
        
        let priceAdded = (finalPrice / 100) * (Double(valueAdded) ?? 0)
        finalPrice = finalPrice + priceAdded
        
        couponResponseLabel.text = ("Coupon discount value").localiz() + " "  + "\(couponValue)%"
        totalAfterDiscountLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
    }
    
    func getCouponFailure(_ response: String) {
        discountView.isHidden = true

        couponResponseLabel.text = response
        checkBtn.setImage(#imageLiteral(resourceName: "warning"), for: .normal)
    }
    
    func getReservationSuccess(_ response: ReservationResponse) {
        reservationData?.reservation_id = response.reservation_id ?? 0
        reservationData?.services_total = response.net ?? 0
        Helper.saveObjectDefault(key: Constants.userDefault.userReservation, value: reservationData as Any)

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

extension ReservationDataVC: UITextFieldDelegate {
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
