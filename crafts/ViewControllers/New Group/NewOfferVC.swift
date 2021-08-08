//
//  NewOfferVC.swift
//  crafts
//
//  Created by AL Badr  on 1/19/21.
//

import UIKit

class NewOfferVC: UIViewController {
    @IBOutlet weak var offerPriceTF: UITextField!

    fileprivate var presenter: NewOfferPresenter?
    
    var service_id: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LanguageManger.shared.currentLanguage == .ar {
            offerPriceTF.placeholder = "Offer price".localiz()
            offerPriceTF.textAlignment = .right
        }

        setupKeyboard()
        
        presenter = NewOfferPresenter(self)
    }
 
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        offerPriceTF.inputAccessoryView = toolbar
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addOfferBtn_tapped(_ sender: Any) {
        view.endEditing(true)

        if offerPriceTF.text == "" {
            Helper.showFloatAlert(title: "Enter offer price".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
            
        }else {
            let num = (offerPriceTF.text ?? "").arToEnDigits
            let newNum = num.replacingOccurrences(of: "٫", with: ".")
            offerPriceTF.text = newNum

            let parameters = ["service_id": service_id,
                              "offer_price": offerPriceTF.text ?? ""] as [String:Any]
            presenter?.AddOffer(parameters: parameters)
        }
    }

}

extension NewOfferVC: NewOfferPresenterView {
    func getAddOfferSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        self.dismiss(animated: true)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "offerNotification"), object: nil, userInfo: nil)
    }
    
    func getAddOfferFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
