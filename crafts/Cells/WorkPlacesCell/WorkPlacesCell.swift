//
//  WorkPlacesCell.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class WorkPlacesCell: UICollectionViewCell {
    @IBOutlet weak var workLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

//    func configCell(item: Work_places) {
//        if LanguageManger.shared.currentLanguage == .ar {
//              workLabel.text = (item.city_name ?? "") + " - " + (item.district_name ?? "")
//          }else {
//              workLabel.text = (item.city_name_en ?? "") + " - " + (item.district_name_en ?? "")
//          }
//    }
}
