//
//  ApplyToOrderCell.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 18/02/2021.
//

import UIKit

class ApplyToOrderCell: UICollectionViewCell {
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var applyBtn: RoundedButton!
    @IBOutlet weak var dateBtn: RoundedButton!
    
    @IBOutlet weak var serviceNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var providerName: UILabel!

    public static var INITIAL: String  = "initial"
    public static var DONE: String  = "done"; // Confirmed
    public static var CHANGE_TIME: String  = "waiting_time"
    public static var CANCELED: String  = "cancel"
    
    let greenColor = UIColor(red: 0.00, green: 0.53, blue: 0.26, alpha: 1.00)
    let pinkColor = UIColor(red: 0.78, green: 0.26, blue: 0.28, alpha: 1.00)
    let blueColor = UIColor(red: 0.22, green: 0.63, blue: 0.78, alpha: 1.00)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: OrdersModel) {
        serviceNumber.text = "\(item.id ?? 0)"
        
        if LanguageManger.shared.currentLanguage == .ar {
            serviceName.text = item.department_ar ?? ""
        }else {
            serviceName.text = item.department_en ?? ""
        }

        address.text = item.address ?? ""
        serviceDate.text = item.date ?? ""
        serviceTime.text = item.time ?? ""
        providerName.text = item.client_name ?? ""

        orderStatus.text = "Required".localiz()
        orderStatus.textColor = blueColor
        statusImage.image = #imageLiteral(resourceName: "blue")
        
        let status = item.status ?? ""
        
        if status == "pending" {
            applyBtn.isHidden = true
            dateBtn.isHidden = true

        }else {
            applyBtn.isHidden = false
            dateBtn.isHidden = false
        }
    }
}
