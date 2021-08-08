//
//  RateServiceProviderVC.swift
//  salon
//
//  Created by AL Badr  on 6/21/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RateServiceProviderVC: UIViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentTF: UITextView!
    @IBOutlet weak var rate: FloatRatingView!
    
    var token: String = ""
    var id: String = ""
    var name: String = ""
    var image: String = ""
    var type: String = ""
    
    var reservationId: Int = 0
    
    fileprivate var presenter: RateProviderPresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        userName.text = name
        userImage.sd_setImage(with: URL(string: SITE_URL + image))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        type = userDate?.type ?? ""

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupKeyboard()
    
        presenter = RateProviderPresenter(self)
        
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        commentTF.inputAccessoryView = toolbar
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateBtn_tapped(_ sender: Any) {
        if commentTF.text == "" {
            Helper.showFloatAlert(title: "Please enter your comment".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            if rate.rating == 0 {
                Helper.showFloatAlert(title: "Please rate the service".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            }else {
                rateProvider()
            }
        }
    }
    
    func rateProvider() {
        let parameters = ["user_id" : id,
                          "reservation_id": reservationId,
                          "rate": rate.rating,
                          "text": commentTF.text ?? ""] as [String : Any]
        
        presenter?.RateProvider(parameters: parameters)
    }
    
    func endReservationFromClient() {
        let parameters = ["api_token" : token,
                          "id": reservationId] as [String : Any]
        
        presenter?.endClientReservation(parameters: parameters)
    }
    
}

extension RateServiceProviderVC: RateProviderPresenterView {
    func setRateProviderSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        if type == "client"  {
            endReservationFromClient()
        }else {
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        }
    }
    
    func setRateProviderFailure(_ message: String) {
        if message == "تم التقييم من قبل" {
            endReservationFromClient()
        }else {
            Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
        }
    }
    
    func getEndClientReservationSuccess(_ message: String) {
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
    }
    
    func getEndClientReservationFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
