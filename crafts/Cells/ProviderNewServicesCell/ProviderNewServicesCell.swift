//
//  ProviderNewServicesCell.swift
//  crafts
//
//  Created by AL Badr  on 1/18/21.
//

import UIKit

class ProviderNewServicesCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!

    @IBOutlet weak var addOfferBtn: GradientButton!
    @IBOutlet weak var removeOfferBtn: GradientButton!
    @IBOutlet weak var removeServiceBtn: GradientButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        image.layer.borderWidth = 1
        image.layer.cornerRadius = 8
        image.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configureCell(item: SubDepartmentsModel) {
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.name ?? ""
        }else {
            name.text = item.name_en ?? ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))
        
        let basePrice = Double(item.price ?? "") ?? 0
        let discountPrice = Double(item.price_after_discount ?? "") ?? 0
        
        priceLabel.text = "\(basePrice) " + ("SAR".localiz())
        discountLabel.text = "\(discountPrice) " + ("SAR".localiz())
        
        if discountPrice == 0.0 {
            discountLabel.isHidden = true
            
            priceLabel.textColor = UIColor(named: "primaryColor")
            
        }else {
            discountLabel.isHidden = false

            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceLabel.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            
            priceLabel.attributedText = attributeString
            
            priceLabel.textColor = .darkGray
            discountLabel.textColor = UIColor(named: "primaryColor")
        }
   
    }

}
