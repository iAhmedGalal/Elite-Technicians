//
//  CancelClientCell.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class CancelClientCell: UICollectionViewCell {
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var cancelReasonBtn: RoundedButton!
    
    @IBOutlet weak var serviceNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var paymentType: UILabel!
    @IBOutlet weak var totalService: UILabel!
    @IBOutlet weak var valueAdded: UILabel!
    @IBOutlet weak var paymentFeeOnArrival: UILabel!
    @IBOutlet weak var requiredAmount: UILabel!
    
    @IBOutlet weak var paymentFeeView: UIStackView!
    
    @IBOutlet weak var addValueView: UIStackView!

    
    public static var INITIAL: String  = "initial"
    public static var DONE: String  = "done"; // Confirmed
    public static var CHANGE_TIME: String  = "waiting_time"
    public static var CANCELED: String  = "cancel"
    
    
    
    let greenColor = UIColor(red: 0.00, green: 0.53, blue: 0.26, alpha: 1.00)
    let pinkColor = UIColor(red: 0.78, green: 0.26, blue: 0.28, alpha: 1.00)
    let blueColor = UIColor(red: 0.22, green: 0.63, blue: 0.78, alpha: 1.00)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        paymentFeeView.isHidden = false
    }
    
    func configCell(item: OrdersModel) {
        
        serviceNumber.text = "\(item.reservation_id )"
        orderStatus.text = item.reservation_status
        
        if item.reservation_details.isEmpty == false {
            if LanguageManger.shared.currentLanguage == .ar {
                serviceName.text = item.reservation_details[0].details_department_name ?? ""
            }else {
                serviceName.text = item.reservation_details[0].details_department_name_en ?? ""
            }
        }
        
        
        address.text = item.reservation_address
        serviceDate.text = item.reservation_date
        serviceTime.text = item.reservation_time
        providerName.text = item.reservation_provider_name
        totalService.text = item.reservation_total + " " + ("SAR".localiz())
        valueAdded.text = item.reservation_addValue + " " + ("SAR".localiz())
        requiredAmount.text = item.reservation_net + " " + ("SAR".localiz())
        
        let addValue = item.reservation_addValue
        
        if addValue == "" || addValue == "0" {
            addValueView.isHidden = true
        }else {
            addValueView.isHidden = false
        }
        
        let payType = item.reservation_paymentType
        
        if payType == Constants.PayMethods.ON_DELIVER {
            paymentFeeView.isHidden = false
            paymentType.text = "Pay on delivery".localiz()
            
            let userSettings = Helper.getObjectDefault(key: Constants.userDefault.userSettings) as? SettingsModel
            let fee = userSettings?.every_service_money ?? "0"
            paymentFeeOnArrival.text = fee + " " + ("SAR".localiz())
            
        }else if payType == Constants.PayMethods.WALLET {
            paymentType.text = "Pay in points".localiz()
            paymentFeeView.isHidden = false

        }else if payType == Constants.PayMethods.BANK {
            paymentType.text = "Bank transfer".localiz()
            paymentFeeView.isHidden = false

        }else {
            paymentType.text = "Electronic Payment".localiz()
            paymentFeeView.isHidden = false
        }
        
        orderStatus.text = "Rejected".localiz()
        orderStatus.textColor = pinkColor
        statusImage.image = #imageLiteral(resourceName: "pink")
    }
}
