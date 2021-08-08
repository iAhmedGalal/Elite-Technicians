//
//  EPayVC.swift
//  salon
//
//  Created by AL Badr  on 6/25/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import WebKit

class EPayVC: UIViewController {
    
    var reservationId: Int = 0
    var commissionMoney: String = ""
    
    var token: String = ""
    var lang: String = ""

    var fromCommission: Bool = false
        
    var webView: WKWebView!
    var link: String = ""

    fileprivate var presenter: EPayPresenter?
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let userData = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userData?.api_token ?? ""
        lang = LanguageManger.shared.currentLanguage.rawValue as String
        
        link = String(format: Constants.Urls.PAYMENT_BASE_URL, "\(reservationId)", token, lang)
        let url = URL(string: link)
        
        print("link", link)
        
        webView.load(URLRequest(url: url!))
        
        presenter = EPayPresenter(self)
    }
    
    func ReservationPayment(paymentWay: String) {
        let reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        let reservationId =  reservationData?.reservation_id ?? 0
        let total = Int(reservationData?.services_total ?? 0)
        print("total reservationData", total)
        
        let parameters = ["reservation_id": reservationId,
                          "money_paid": total,
                          "e_payment_response": "e_payment_response",
                          "payment_way": paymentWay] as [String:Any]
        
        presenter?.reservationPayment(parameters: parameters, imageList: [])
    }
}

extension EPayVC: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading", webView.url as Any)
 
        if webView.url == URL(string: SITE_URL + "info") {
            ReservationPayment(paymentWay: Constants.PayMethods.E_PAYMENT)
        }
    }
}

extension EPayVC: EPayPresenterView {
    func getPaymentSuccess(_ message: String) {
        Helper.removeKeyUserDefault(key: Constants.userDefault.userReservation)

        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
            name:Constants.storyBoard.main,
            bundle: nil
        ).instantiateViewController(withIdentifier: "mainNC")
    }
    
    func getPaymentFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
