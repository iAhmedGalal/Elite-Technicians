//
//  CommentsCell.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {

    @IBOutlet weak var image: CircleImage!
    @IBOutlet weak var certifiedImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rate: FloatRatingView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var objectionView: RoundRectView!
    @IBOutlet weak var objectionBtn: UIButton!
    
    var type: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        type = userDate?.type ?? ""

        
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height / 2
        
        
    }
    
    func configureCell(item: CommentsModel){
        if type == "provider" {
            name.text = item.rate_client ?? ""
        }else {
            name.text = item.rate_provider ?? ""
        }

        date.text = item.rate_date ?? ""
        comment.text = item.comment ?? ""
        rate.rating = Double(item.rate ?? "0") ?? 0
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.rater_image ?? "")))
        
        let verified = item.provider_verification ?? false
        
        if verified {
            certifiedImage.isHidden = false
        }else {
            certifiedImage.isHidden = true
        }
        
    }

}
