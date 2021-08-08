//
//  InformManagementVC.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class InformManagementVC: UIViewController {

    @IBOutlet weak var reportTF: UITextView!
    
    var orderId: Int = 0
    
    fileprivate var presenter: InformManagementPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboard()
        
        if LanguageManger.shared.currentLanguage == .ar {
            reportTF.text = "Enter your report".localiz()
            reportTF.textAlignment = .right
        }
        
        presenter = InformManagementPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        reportTF.inputAccessoryView = toolbar
        reportTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("orderId", orderId)
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtn_tapped(_ sender: Any) {
        if reportTF.text == "" {
            Helper.showFloatAlert(title: "Please enter your report".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            sendReport()
        }
    }
    
    func sendReport() {
        let parameters = ["reservation_id" : orderId,
                          "reason": reportTF.text ?? ""] as [String : Any]
        
        presenter?.managementReport(parameters: parameters)
    }
}

extension InformManagementVC :InformManagementPresenterView{
    func setReportSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ordersNotification"), object: nil, userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setReportFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension InformManagementVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reportTF.text == "Enter your report".localiz() {
            reportTF.text = ""
        }
        
        reportTF.textColor = .black
    }
}
