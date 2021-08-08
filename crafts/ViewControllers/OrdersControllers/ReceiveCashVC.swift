//
//  ReceiveCashVC.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ReceiveCashVC: UIViewController {

    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var reservationId: Int = 0
    var total: String = ""
    
    fileprivate var presenter: ReceiveCashPresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        requiredLabel.text = total
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ReceiveCashPresenter(self)
        
        if LanguageManger.shared.currentLanguage == .ar {
            amountTF.placeholder = "المبلغ"
            amountTF.textAlignment = .right
        }
        
        setupKeyboard()
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.amountTF.inputAccessoryView = toolbar
        self.amountTF.keyboardType = .decimalPad
    }

    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtn_tapped(_ sender: Any) {
        if amountTF.text == "" {
            Helper.showFloatAlert(title: "Enter money paid".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            
            let num = amountTF.text ?? ""
            
            var newNum = num.arToEnDigits
            
            newNum = newNum.replacingOccurrences(of: "٫", with: ".")
            print("newNum", newNum)

            amountTF.text = newNum
            
            print(Double(amountTF.text ?? "") ?? 0)
            print(Double(total) ?? 0)

            if (Double(amountTF.text ?? "") ?? 0) < (Double(total) ?? 0) {
                errorLabel.text = "Paid amount is less than required".localiz()
            }else {
                view.endEditing(true)
                errorLabel.text = ""
                
                let parameters = ["id" : reservationId,
                                  "money_paid": amountTF.text ?? ""] as [String : Any]
                
                presenter?.endCashOrder(parameters: parameters)
            }
        }
    }
}

extension ReceiveCashVC: ReceiveCashPresenterView {
    func setCashSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        self.dismiss(animated: true, completion: nil)
        
        var objectInfo = [String: Int]()
        
        objectInfo["reservationId"] = reservationId
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "rateNotification"), object: nil, userInfo: objectInfo)
    }
    
    func setCashFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}

extension String {
    public var arToEnDigits : String {
        let arabicNumbers = ["٠": "0","١": "1","٢": "2","٣": "3","٤": "4","٥": "5","٦": "6","٧": "7","٨": "8","٩": "9"]
        var txt = self
        arabicNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
        return txt
    }
    
}
