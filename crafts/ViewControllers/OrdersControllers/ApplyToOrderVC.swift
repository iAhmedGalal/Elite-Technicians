//
//  ApplyToOrderVC.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 21/02/2021.
//

import UIKit

class ApplyToOrderVC: UIViewController {
    
    @IBOutlet weak var priceTF: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var describtionTF: UITextView!
    
    var reservationId: Int = 0
    var date: String = ""
    var time: String = ""
    var describtion: String = ""
    
    fileprivate var presenter: ApplyOrderPresenter?
    
    override func viewWillAppear(_ animated: Bool) {
        dateLabel.text = date
        timeLabel.text = time
        describtionTF.text = describtion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if LanguageManger.shared.currentLanguage == .ar {
            priceTF.placeholder = "تكلفة الخدمة"
            priceTF.textAlignment = .right
        }

        setupKeyboard()
        
        presenter = ApplyOrderPresenter(self)
    }
    
    func setupKeyboard() {
        let toolbar = setupKeyboardToolbar()
        self.priceTF.inputAccessoryView = toolbar
        self.priceTF.keyboardType = .decimalPad
    }
    
    @IBAction func backBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func applyBtn_tapped(_ sender: Any) {
        if priceTF.text == "" {
            Helper.showFloatAlert(title: "Enter Service Cost".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            let num = (priceTF.text ?? "").arToEnDigits
            let newNum = num.replacingOccurrences(of: "٫", with: ".")
            priceTF.text = newNum
            
            view.endEditing(true)
            Apply()
        }
    }
    
    @IBAction func selectDatesBtn_tapped(_ sender: Any) {

    }
    
    func Apply() {
        let parameters = ["order_id" : reservationId,
                          "date" : date,
                          "time" : time,
                          "cost": priceTF.text ?? ""] as [String : Any]
        
        presenter?.applyToOrder(parameters: parameters)
    }

}

extension ApplyToOrderVC: ApplyOrderPresenterView {
    func setApplySuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        
        self.dismiss(animated: true, completion: nil)

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "applyNotification"), object: nil, userInfo: nil)
    }
    
    func setApplyFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
