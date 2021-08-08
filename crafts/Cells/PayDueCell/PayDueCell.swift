//
//  PayDueCell.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class PayDueCell: UICollectionViewCell {
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var requiredAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var totalServices: UILabel!
    @IBOutlet weak var valueAdded: UILabel!
    @IBOutlet weak var commission: UILabel!
    @IBOutlet weak var remainingBalance: UILabel!
    @IBOutlet weak var deservedAmount: UILabel!
    
    @IBOutlet weak var bayBtn: RoundedButton!
    
    let greenColor = UIColor(red: 0.00, green: 0.65, blue: 0.32, alpha: 1.00)
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configPayCell(item: DueModel) {
        orderNumber.text = item.reservation_id ?? ""
        serviceDate.text = item.reservation_date ?? ""
        requiredAmount.text = (item.reservation_money_required ?? "") + " " + ("SAR".localiz())
        paidAmount.text = (item.reservation_money_paid ?? "") + " " + ("SAR".localiz())
        totalServices.text = (item.reservation_total ?? "") + " " + ("SAR".localiz())
        valueAdded.text = (item.reservation_add_value ?? "") + " " + ("SAR".localiz())
        commission.text = (item.reservation_commission_money ?? "") + " " + ("SAR".localiz())
        remainingBalance.text = (item.reservation_rest ?? "") + " " + ("SAR".localiz())
        deservedAmount.text = (item.required_from_provider ?? "") + " " + ("SAR".localiz())
        
        if item.status == "paid" {
            bayBtn.isEnabled = false
            bayBtn.backgroundColor = .lightGray
            bayBtn.setTitleColor(.black, for: .normal)
            
            let agree = item.admin_agree ?? ""
            if agree == "" {
                bayBtn.setTitle("Pending Admin Agreement".localiz(), for: .normal)
            }else {
                bayBtn.setTitle("Payment completed".localiz(), for: .normal)
            }
            
        }else {
            bayBtn.isEnabled = true
            bayBtn.backgroundColor = greenColor
            bayBtn.setTitle("PAY THE DUE".localiz(), for: .normal)
            bayBtn.setTitleColor(.white, for: .normal)
        }
    }
    
    func configRequestCell(item: DueModel) {
        orderNumber.text = item.reservation_id ?? ""
        serviceDate.text = item.reservation_date ?? ""
        requiredAmount.text = (item.reservation_money_required ?? "") + " " + ("SAR".localiz())
        paidAmount.text = (item.reservation_money_paid ?? "") + " " + ("SAR".localiz())
        totalServices.text = (item.reservation_total ?? "") + " " + ("SAR".localiz())
        valueAdded.text = (item.reservation_add_value ?? "") + " " + ("SAR".localiz())
        commission.text = (item.reservation_commission_money ?? "") + " " + ("SAR".localiz())
        remainingBalance.text = (item.reservation_rest ?? "") + " " + ("SAR".localiz())
        deservedAmount.text = (item.payable_to_provider ?? "") + " " + ("SAR".localiz())
    }
  
}
