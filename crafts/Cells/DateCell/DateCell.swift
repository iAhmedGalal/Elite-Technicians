//
//  DateCell.swift
//  salon
//
//  Created by AL Badr  on 7/7/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var suggestedTime: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: NewDates) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: item.suggest_date ?? "")
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "EEEE"
        let newDateString = newDateFormatter.string(from: date ?? Date())
        

        suggestedTime.text = newDateString + " " + (item.suggest_time)
    }

}
