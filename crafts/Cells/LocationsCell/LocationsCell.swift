//
//  LocationsCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class LocationsCell: UICollectionViewCell {
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var chooseRadioBtn: RadioButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: LocationsModel) {
        location.text = item.place_title ?? ""
    }
    
    func configDatesCell(item: NewDates) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: item.suggest_date ?? "")
        
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateFormat = "EEEE yyyy-MM-dd"
        let newDateString = newDateFormatter.string(from: date ?? Date())
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let time = timeFormatter.date(from: item.suggest_time)
        
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "h:mm a"
        let newTimeString = newTimeFormatter.string(from: time ?? Date())
        
        location.text = (newDateString) + " - " + (newTimeString)
    }
    
    func setSelected(selected: Bool) {
        if selected {
            chooseRadioBtn.isChecked = true
        }else {
            chooseRadioBtn.isChecked = false
        }
    }
    
    func isSelected(selected: Bool) {
        setSelected(selected: selected)
    }
    
}
