//
//  SpecialistCell.swift
//  salon
//
//  Created by AL Badr  on 6/11/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SpecialistCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var verifiedImage: UIImageView!

    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var rate: FloatRatingView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var subCategoriesArray: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.borderColor = UIColor.black.cgColor

    }
    
    func configureCell(item: Providers) {
        title.text = item.user_name ?? ""
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.user_image ?? "")))
        rate.rating = Double(item.rate ?? 0)
        
    }
    
    func configFavouriteCell(item: FavouritesModel) {
        title.text = item.user_name ?? ""

        image.sd_setImage(with: URL(string: SITE_URL + (item.user_image ?? "")))
        rate.rating = Double(item.rate ?? 0)
        
        let verified = item.verified ?? false
        
        if verified {
            verifiedImage.isHidden = false
        }else {
            verifiedImage.isHidden = true
        }
    }

}
