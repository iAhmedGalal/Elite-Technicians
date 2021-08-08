//
//  MessagesCell.swift
//  salon
//
//  Created by AL Badr  on 6/18/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class MessagesCell: UICollectionViewCell {
    
    @IBOutlet weak var image: CircleImage!
    @IBOutlet weak var lastMessageImage: UIImageView!

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func configureCell(item: MessagesModel){
        name.text = item.client_name ?? ""
        time.text = item.the_date ?? ""
        
        image.sd_setImage(with: URL(string: item.client_image_url ?? ""))
        
        let lastMessageType = item.last_message_type ?? ""
        
        if lastMessageType == "image" {
            message.text = "Image".localiz()
            lastMessageImage.isHidden = false
            
        }else {
            message.text = item.last_message ?? ""
            lastMessageImage.isHidden = true
        }
    }
}
