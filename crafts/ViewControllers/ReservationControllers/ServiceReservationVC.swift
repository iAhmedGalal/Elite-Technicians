//
//  ServiceReservationVC.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ServiceReservationVC: UIViewController {
    /*
    @IBOutlet weak var subServicesCV: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var totalAfterVatLabel: UILabel!
    
    @IBOutlet weak var taxNumberLabel: UILabel!
    
    @IBOutlet weak var totalView: UIStackView!
    @IBOutlet weak var vatView: UIStackView!
    @IBOutlet weak var totalAfterVatView: UIStackView!
    @IBOutlet weak var taxNumberView: UIStackView!

    
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var couponTF: UITextField!
    @IBOutlet weak var couponResponseLabel: UILabel!
    
    @IBOutlet weak var stackHeight: NSLayoutConstraint!

    var subServicesList: [DepartmentsData] = []
    var service_ids: [Int] = []
    var valueAdded: String = ""
    var couponValue: Int = 0
    var totalPrice: Double = 0
    var finalPrice: Double = 0
    
    var discountPercentage: String = ""
    
    var reaservationData: ReservationModel?
    
    fileprivate var presenter: ServiceReservationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybourdWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        reaservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginData
        discountPercentage = userDate?.provider_discount_percentage ?? ""
        
        if LanguageManger.shared.currentLanguage == .ar {
            couponTF.placeholder = "ادخل الكوبون"
            couponTF.textAlignment = .right
        }
        
        initView()
        setupKeyboard()
        getSettings()
    }
    
    @objc func keybourdWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo as? [String : AnyObject] else { return }
        
        let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        let keyboardRect = frame?.cgRectValue
        let keyboardHeight = (keyboardRect?.height ?? 16) - 128
        stackHeight.constant = keyboardHeight
    }
    
    @objc func keybourdWillHide(notification: NSNotification){
        stackHeight.constant = 16
    }
    
    func initView() {
        totalPrice = reaservationData?.services_total ?? 0
        totalLabel.text = "\(totalPrice)" + " " + ("SAR".localiz())
        subServicesList = reaservationData?.subDepartments ?? []
        service_ids = reaservationData?.service_ids ?? []

        subServicesCV.dataSource = self
        subServicesCV.delegate = self
        subServicesCV.register(UINib(nibName: "ReservationServicesCell", bundle: nil), forCellWithReuseIdentifier: "ReservationServicesCell")
        
        subServicesCV.reloadData()
        
        presenter = ServiceReservationPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.couponTF.inputAccessoryView = toolbar
    }
    
    func getSettings() {
        let userSettings = Helper.getObjectDefault(key: Constants.userDefault.userSettings) as? SettingsModel
        valueAdded = userSettings?.value_added ?? "0"
        
        if valueAdded == "0" {
            vatView.isHidden = true
            totalAfterVatView.isHidden = true
            taxNumberView.isHidden = true
            
            finalPrice = totalPrice
            
        }else {
            vatView.isHidden = false
            totalAfterVatView.isHidden = false
            taxNumberView.isHidden = false
            
            taxNumberLabel.text = userSettings?.tax_number ?? "0"
            
            vatLabel.text = (valueAdded) + "%"
            
            let priceAdded = (totalPrice / 100) * (Double(valueAdded) ?? 0)
            finalPrice = totalPrice + priceAdded
            totalAfterVatLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
        }
        
    }
    
    @IBAction func checkCouponBtn_tapped(_ sender: Any) {
        let parameters = ["code": couponTF.text ?? ""] as [String:Any]
        presenter?.getCoupon(parameters: parameters)
    }
    
    @IBAction func nextBtn_tapped(_ sender: Any) {
        reaservationData?.services_total = finalPrice
        reaservationData?.service_ids = service_ids
        Helper.saveObjectDefault(key: Constants.userDefault.userReservation, value: reaservationData as Any)
        
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReservationDataVC") as! ReservationDataVC
        vc.title = "Determine lacation and time".localiz()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension ServiceReservationVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 16, height: 95)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subServicesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReservationServicesCell", for: indexPath) as?
            ReservationServicesCell else {
                return UICollectionViewCell()
        }
        
        cell.configureCell(item: subServicesList[indexPath.row])
                    
        cell.delete.addTarget(self, action: #selector(deleteService_tapped(_:)), for: UIControl.Event.touchUpInside)
        cell.delete.tag = indexPath.row
        
        return cell
    }
    
    @objc func deleteService_tapped(_ sender: UIButton) {
        if let i = service_ids.firstIndex(of: subServicesList[sender.tag].department_id ?? 0) {
            service_ids.remove(at: i)

            subServicesList.remove(at: sender.tag)
            subServicesCV.reloadData()
            
            totalPrice = 0
            
            for service in subServicesList {
                 totalPrice += (Double(service.department_price ?? "0") ?? 0)
            }
            
            let priceAdded = (totalPrice / 100) * (Double(valueAdded) ?? 0)
            finalPrice = totalPrice + priceAdded
            totalAfterVatLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
            
            if couponValue != 0 {
                let priceDiscount = (totalPrice / 100) * (Double(couponValue))
                finalPrice = totalPrice - priceDiscount
                
                let priceAdded = (finalPrice / 100) * (Double(valueAdded) ?? 0)
                finalPrice = finalPrice + priceAdded
                
                couponResponseLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
            }
        }else {
            print("Index Not Found")
        }
    }
}

extension ServiceReservationVC: ServiceReservationPresenterView {
    func getCouponSuccess(_ response: CouponModel) {
        checkBtn.setImage(#imageLiteral(resourceName: "checkgray"), for: .normal)

        couponValue = response.discount ?? 0
               
        let priceDiscount = (totalPrice / 100) * (Double(couponValue))
        finalPrice = totalPrice - priceDiscount
        
        let priceAdded = (finalPrice / 100) * (Double(valueAdded) ?? 0)
        finalPrice = finalPrice + priceAdded
        
        couponResponseLabel.text = "\(finalPrice)" + " " + ("SAR".localiz())
        
        reaservationData?.coupon_percentage = response.discount ?? 0
        reaservationData?.coupon_id = response.coupon_id ?? 0
    }
    
    func getCouponFailure(_ response: String) {
        couponResponseLabel.text = response
        checkBtn.setImage(#imageLiteral(resourceName: "warning"), for: .normal)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
 
 */
 
 }
    
