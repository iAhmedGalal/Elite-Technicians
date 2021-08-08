//
//  OrderApplicantsCell.swift
//  crafts
//
//  Created by Mahmoud Elzaiady on 21/02/2021.
//

import UIKit

class OrderApplicantsCell: UICollectionViewCell {
    @IBOutlet weak var acceptBtn: RoundedButton!
    @IBOutlet weak var profileBtn: RoundedButton!
   
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var providerName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(item: Providers) {
        serviceDate.text = item.date ?? ""
        serviceTime.text = item.time ?? ""
        providerName.text = item.name ?? ""
    }
}
