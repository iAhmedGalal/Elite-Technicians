//
//  RejectionReasonsVC.swift
//  salon
//
//  Created by AL Badr  on 6/21/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class RejectionReasonsVC: UIViewController {
    
    @IBOutlet weak var reasonsTF: UITextView!
    
    var orderId: Int = 0
    
    fileprivate var presenter: CancelReasonsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            reasonsTF.text = "أسباب الرفض"
            reasonsTF.textAlignment = .right
        }
        
        presenter = CancelReasonsPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        reasonsTF.inputAccessoryView = toolbar
        reasonsTF.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        print("orderId", orderId)
    }

    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if reasonsTF.text == "" {
            Helper.showFloatAlert(title: "Please enter your rejection reasons".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            sendCancelReasons()
        }
    }
    
    func sendCancelReasons() {
         let parameters = ["id" : orderId,
                           "reason": reasonsTF.text ?? ""] as [String : Any]
         
         presenter?.sendCancelReasons(parameters: parameters)
     }
    
}

extension RejectionReasonsVC: CancelReasonsPresenterView {
    func setCancelReasonsSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setCancelReasonsFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension RejectionReasonsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reasonsTF.text == "Rejection Reasons".localiz() {
            reasonsTF.text = ""
            reasonsTF.textColor = .black
        }
    }
}

