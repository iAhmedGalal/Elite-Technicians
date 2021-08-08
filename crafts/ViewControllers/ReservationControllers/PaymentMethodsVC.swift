//
//  PaymentMethodsVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PaymentMethodsVC: UIViewController {
    @IBOutlet weak var backBtn: UIBarButtonItem!

    fileprivate var presenter: BankTransferPresenter?
    
    var reservationId: Int = 0
    var total: String = ""
    var paymentWay: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if LanguageManger.shared.currentLanguage == .ar {
            backBtn.image = #imageLiteral(resourceName: "forwward")
        }else {
            backBtn.image = #imageLiteral(resourceName: "back")
        }
        
        let reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        total = String(reservationData?.services_total ?? 0)

        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "completeNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GoToOrdersNotifications), name: NSNotification.Name(rawValue: "doneNotification"), object: nil)

    }
    
    @objc func GoToOrdersNotifications(notification: NSNotification){
        if notification.name.rawValue == "completeNotification" {
            UIApplication.shared.windows[0].rootViewController = UIStoryboard(
                name:Constants.storyBoard.main,
                bundle: nil
            ).instantiateViewController(withIdentifier: "mainNC")
                        
        }else {
            let story = UIStoryboard(name: Constants.storyBoard.reservation, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ReservationDoneVC") as! ReservationDoneVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func exitChat_tap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Chosen payment method will be: Pay When The Service Provider Arrives".localiz(), message:"", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back to home screen".localiz(), style: .default, handler: backToHome))
        alert.addAction(UIAlertAction(title: "Cancel".localiz(), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func backToHome(alert: UIAlertAction!) {
        Helper.ShowMainScreen(controller: self)
    }
    
    @IBAction func bankBtn_tapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "BankTransferVC") as! BankTransferVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
        
        vc.total = total
        vc.reservationId = reservationId
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func ePayBtn_tapped(_ sender: Any) {
//        paymentWay = Constants.PayMethods.E_PAYMENT
//        ReservationPayment(paymentWay: paymentWay)
        
        let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EPayVC") as! EPayVC
        vc.reservationId = reservationId
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    @IBAction func cashBtn_tapped(_ sender: Any) {
        paymentWay = Constants.PayMethods.ON_DELIVER
        ReservationPayment(paymentWay: paymentWay)
    }
    
    @IBAction func pointsBtn_tapped(_ sender: Any) {
        paymentWay = Constants.PayMethods.WALLET
        ReservationPayment(paymentWay: paymentWay)
    }
    
    func ReservationPayment(paymentWay: String) {
        presenter = BankTransferPresenter(self)
        
        let reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        let reservationId =  reservationData?.reservation_id ?? 0
  
        let parameters = ["reservation_id": reservationId,
                          "money_paid": total,
                          "e_payment_response": "e_payment_response",
                          "payment_way": paymentWay] as [String:Any]
        
        presenter?.BankTransfer(parameters: parameters, imageList: [])
    }

}

extension PaymentMethodsVC: BankTransferPresenterView {
    func getBankAccountsSuccess(_ response: [BankAccountsModel]) {}
    
    func getBankAccountsFailure() {}
    
    func getSendTransferSuccess(_ message: String) {
        if paymentWay == Constants.PayMethods.E_PAYMENT {
            let storyboard = UIStoryboard(name: Constants.storyBoard.reservation, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EPayVC") as! EPayVC
            vc.reservationId = reservationId
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let story = UIStoryboard(name: Constants.storyBoard.reservation, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier:"ReservationDoneVC") as! ReservationDoneVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor  = UIColor(white: 1, alpha: 0.5)
            self.navigationController?.present(vc, animated: true, completion: nil)
        }

        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
    }
    
    func getSendTransferFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }

}

