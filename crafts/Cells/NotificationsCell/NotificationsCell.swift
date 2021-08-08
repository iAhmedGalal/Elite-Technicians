//
//  NotificationsCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class NotificationsCell: UICollectionViewCell {
    @IBOutlet weak var cellView: RoundRectView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cellView.layer.cornerRadius = 15

        
    }
    
    func configureCell(item: NotificationsModel){
        if item.read ?? false == false {
            notificationImage.image = #imageLiteral(resourceName: "notificationspink")
        }else {
            notificationImage.image = #imageLiteral(resourceName: "notificationssgray")
        }
        
        time.text = item.time
        date.text = item.date
        
        if LanguageManger.shared.currentLanguage == .ar {
            title.text = item.message
        }else {
            title.text = item.message_en
        }
             
    }

}
