//
//  ArticlesCell.swift
//  salon
//
//  Created by AL Badr  on 6/11/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ArticlesCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(item: Articles) {
        
        if LanguageManger.shared.currentLanguage == .ar {
            title.text = item.title ?? ""
        }else {
            title.text = item.title_en ?? ""
        }
        
        image.sd_setImage(with: URL(string: SITE_URL + (item.image ?? "")))
    }

}
