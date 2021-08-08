//
//  ProviderServicesCell.swift
//  crafts
//
//  Created by AL Badr  on 1/17/21.
//

import UIKit

class ProviderServicesCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var check: CheckBox!
    
    var type: String = ""
    var token: String = ""

    var reservationData: ReservationModel?
    var service_ids: [Int] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reservationData = Helper.getObjectDefault(key: Constants.userDefault.userReservation) as? ReservationModel
        service_ids = reservationData?.service_ids ?? []

        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""
        token = userDate?.api_token ?? ""
        
        image.layer.cornerRadius = 10
    }
    
    func configureCell(item: SubDepartmentsModel) {
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.name ?? ""
        }else {
            name.text = item.name_en ?? ""
        }
        
        let basePrice = Double(item.price ?? "") ?? 0
        let discountPrice = Double(item.price_after_discount ?? "") ?? 0
        
        price.text = "\(basePrice) " + ("SAR".localiz())
        discount.text = "\(discountPrice) " + ("SAR".localiz())
        
        if discountPrice == 0.0 {
            discount.isHidden = true
            
            price.textColor = UIColor(named: "primaryColor")
            
        }else {
            discount.isHidden = false

            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: price.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            
            price.attributedText = attributeString
            
            price.textColor = .darkGray
        }
   
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))

        
        if token == "" {
            check.isHidden = true
            check.isEnabled = false
        }else {
            if type == "provider" {
                check.isHidden = true
                check.isEnabled = false
            }else {
                check.isHidden = false
                check.isEnabled = true
            }
        }
        
        if service_ids.contains(item.id ?? 0) {
            check.isChecked = true
        }else {
            check.isChecked = false
        }
        
    }


}
