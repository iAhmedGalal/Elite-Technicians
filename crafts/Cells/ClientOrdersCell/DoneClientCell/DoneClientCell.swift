//
//  DoneClientCell.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class DoneClientCell: UICollectionViewCell {
    @IBOutlet weak var statusImage: UIImageView!

    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var payAndRateBtn: RoundedButton!

    @IBOutlet weak var trackBtn: RoundedButton!
    @IBOutlet weak var chatBtn: RoundedButton!
    @IBOutlet weak var trackView: UIStackView!
    
    @IBOutlet weak var bankBtn: RoundedButton!
    @IBOutlet weak var ePayBtn: RoundedButton!
    @IBOutlet weak var payView: UIStackView!
    
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
        
        
        trackBtn.isHidden = true
        cancelBtn.isHidden = true
        ePayBtn.isHidden = true
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
        let follow = item.reservation_if_follow_open
        
        if payType == Constants.PayMethods.ON_DELIVER {
            paymentFeeView.isHidden = false
            payView.isHidden = false
            
            paymentType.text = "Pay on delivery".localiz()
            
            let userSettings = Helper.getObjectDefault(key: Constants.userDefault.userSettings) as? SettingsModel
            let fee = userSettings?.every_service_money ?? "0"
            paymentFeeOnArrival.text = fee + " " + ("SAR".localiz())
            
            checkTrackBtn(followOpen: follow)
            
        }else if payType == Constants.PayMethods.WALLET {
            paymentType.text = "Pay in points".localiz()
            paymentFeeView.isHidden = false
            payView.isHidden = true
            
            checkTrackBtn(followOpen: follow)
            
        }else if payType == Constants.PayMethods.BANK {
            paymentType.text = "Bank transfer".localiz()
            paymentFeeView.isHidden = false
            payView.isHidden = true
            
            checkTrackBtn(followOpen: follow)

        }else {
            paymentType.text = "Electronic Payment".localiz()
            paymentFeeView.isHidden = false
            payView.isHidden = false
            
            checkTrackBtn(followOpen: follow)
        }
        
        orderStatus.text = "Confirmed".localiz()
        orderStatus.textColor = greenColor
        statusImage.image = #imageLiteral(resourceName: "green")
    }
    
    func checkTrackBtn(followOpen: Bool) {
        if followOpen {
            trackBtn.isHidden = false
        }else {
            trackBtn.isHidden = true
        }
    }
}
