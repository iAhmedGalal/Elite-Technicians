//
//  SubServiceCell.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class SubServiceCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var image: UIImageView!

    
    var type: String = ""
    var token: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func configureCell(item: SubDepartmentsModel) {
        if LanguageManger.shared.currentLanguage == .ar {
            name.text = item.name_ar ?? ""
        }else {
            name.text = item.name_en ?? ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))

        number.text = String(item.providers_count ?? 0) + "   "
    }
}
