//
//  DiscountRequestVC.swift
//  salon
//
//  Created by AL Badr  on 10/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import DropDown

class DiscountRequestVC: UIViewController {

    @IBOutlet weak var discountBtn: UIButton!
    
    var discounts:[String] = []
    let discountsDropDown = DropDown()
    var selectedDiscount: String = ""
    
    fileprivate var presenter: DiscountRequestPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = DiscountRequestPresenter(self)

        setupDiscountsDropDown()
    }
    
    
    func setupDiscountsDropDown() {
        discountBtn.setTitle("Choose discount percent".localiz(), for: .normal)
        discounts.removeAll()
        
        discounts.append("5%")
        discounts.append("8%")
        discounts.append("10%")
        discounts.append("13%")
        discounts.append("15%")
        
        discountsDropDown.anchorView = discountBtn
        discountsDropDown.bottomOffset = CGPoint(x: 0, y: 0)
        discountsDropDown.dataSource = discounts
        discountsDropDown.selectionAction = { [unowned self](index, item) in
            self.discountBtn.setTitle(item, for: .normal)
            self.selectedDiscount = item
        }
    }
    
    @IBAction func closeBtn_tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func discountBtn_tapped(_ sender: Any) {
        discountsDropDown.show()
    }
    
    @IBAction func requesttBtn_tapped(_ sender: Any) {
        if selectedDiscount == "" {
            Helper.showFloatAlert(title: "Choose discount percent".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
        }else {
            sendDiscountRequest()
        }
    }
    
    func sendDiscountRequest() {
        let discountPercentage = selectedDiscount.dropLast()
        let parameters = ["discount_percentage" : discountPercentage] as [String : Any]
        presenter?.commessionDiscountRequest(parameters: parameters)
    }
    
    
}

extension DiscountRequestVC: DiscountRequestPresenterView {
    func getDiscountRequestSuccess(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertSuccess)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDiscountRequestFailure(_ message: String) {
        Helper.showFloatAlert(title: message, subTitle: "", type: Constants.AlertType.AlertError)
    }
    
    func showConnectionErrorMessage() {
        Helper.showFloatAlert(title: "Check Your Internet Connection".localiz(), subTitle: "", type: Constants.AlertType.AlertError)
    }
}
