//
//  ProviderSheetCell.swift
//  salon
//
//  Created by AL Badr  on 7/13/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ProviderSheetCell: UICollectionViewCell {
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var requiredAmount: UILabel!
    @IBOutlet weak var paidAmount: UILabel!
    @IBOutlet weak var totalServices: UILabel!
    @IBOutlet weak var valueAdded: UILabel!
    @IBOutlet weak var commission: UILabel!
    @IBOutlet weak var remainingBalance: UILabel!
    @IBOutlet weak var deservedAmount: UILabel!
    @IBOutlet weak var paymentType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configProviderSheetCell(item: StatementsModel) {
        orderNumber.text = "\(item.reservation_id ?? 0)"
        serviceDate.text = item.reservation_date ?? ""
        requiredAmount.text = (item.reservation_net ?? "") + " " + ("SAR".localiz())
        paidAmount.text = (item.reservation_money_pay ?? "") + " " + ("SAR".localiz())
        totalServices.text = (item.reservation_total ?? "") + " " + ("SAR".localiz())
        valueAdded.text = (item.reservation_add_value ?? "") + " " + ("SAR".localiz())
        commission.text = (item.reservation_commission ?? "") + " " + ("SAR".localiz())
        remainingBalance.text = (item.reservation_rest ?? "")  + " " + ("SAR".localiz())
        deservedAmount.text = (item.reservation_provider_money ?? "")  + " " + ("SAR".localiz())
        
        if LanguageManger.shared.currentLanguage == .ar {
            paymentType.text = item.reservation_payment_way ?? ""
        }else {
            let method = item.reservation_payment_way_en ?? ""
            
            if method == Constants.PayMethods.ON_DELIVER {
                paymentType.text = "ON DELIVER"

            }else if method == Constants.PayMethods.E_PAYMENT {
                paymentType.text = "Electronic Payment"

            }else if method == Constants.PayMethods.BANK {
                paymentType.text = "Bank Transfer"

            }else if method == Constants.PayMethods.WALLET {
                paymentType.text = "WALLET"
            }
        }
        
        
    }
    
    

}
