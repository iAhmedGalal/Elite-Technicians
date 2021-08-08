//
//  ReservationProvidersCell.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ReservationProvidersCell: UICollectionViewCell {
    @IBOutlet weak var providerImage: UIImageView!
    
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerExperience: UILabel!
    
    @IBOutlet weak var providerRate: FloatRatingView!
    
    @IBOutlet weak var favBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configCell(item: Providers){
        providerName.text = item.user_name ?? ""
        providerExperience.text = String(item.experience ?? 0)
   
        providerRate.rating = Double(item.rate ?? 0)
        
        providerImage.sd_setImage(with: URL(string: SITE_URL + (item.user_image ?? "")))
        
        let isFav = item.isFav ?? false
        
        if isFav {
            favBtn.setImage(#imageLiteral(resourceName: "likepink"), for: .normal)
        }else {
            favBtn.setImage(#imageLiteral(resourceName: "likeborderpink"), for: .normal)
        }
        
    }
 

}
