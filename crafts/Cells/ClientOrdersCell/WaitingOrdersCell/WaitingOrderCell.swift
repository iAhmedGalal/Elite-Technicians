//
//  WaitingOrderCell.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 21/02/2021.
//

import UIKit

class WaitingOrderCell: UICollectionViewCell {

    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var applicantsBtn: RoundedButton!
    @IBOutlet weak var cancelBtn: RoundedButton!
    
    @IBOutlet weak var serviceNumber: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var applicantsNumber: UILabel!


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
        
        let providers = item.providers ?? []
        applicantsNumber.text =  String(providers.count)

        orderStatus.text = "Not Confirmed".localiz()
        orderStatus.textColor = blueColor
        statusImage.image = #imageLiteral(resourceName: "blue")
    }
}
