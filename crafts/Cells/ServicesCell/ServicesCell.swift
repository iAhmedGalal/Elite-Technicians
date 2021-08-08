//
//  ServicesCell.swift
//  salon
//
//  Created by AL Badr  on 6/4/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ServicesCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var selectedView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        image.layer.cornerRadius = image.frame.height / 2
        image.layer.borderColor = UIColor.black.cgColor
        
        selectedView.isHidden = true

    }
    
    func configureCell(item: DepartmentsModel) {
        if LanguageManger.shared.currentLanguage == .ar {
            title.text = item.department_name ?? ""
        }else {
            title.text = item.department_name_en ?? ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))
    }
}
