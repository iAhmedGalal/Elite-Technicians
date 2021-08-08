//
//  ChatCell.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderImage: CircleImage!
    @IBOutlet weak var messageTF: UITextView!
    
    @IBOutlet weak var chatView: UIStackView!
    @IBOutlet weak var avatarMessageView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var messageImageView: UIView!

    var colorOrange = UIColor(red:0.76, green:0.22, blue:0.04, alpha:1.00)

    var token: String = ""
    var userId: String = ""
    var userImage: String = ""
    var clientImage: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        let userDate = Helper.getObjectDefault(key: Constants.userDefault.userData) as? LoginModel
        token = userDate?.api_token ?? ""
        userId = "\(userDate?.id ?? 0)"
        userImage = userDate?.image_url ?? ""
        
        messageView.layer.cornerRadius = 16
        messageImageView.layer.cornerRadius = 16

        senderName.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupClientImage(item: String){
        clientImage = item
    }
    
    func configureCell(item: ChatMessageModel){
        messageTF.text = ""
        
        if item.sender_id ?? "" == userId {
            chatView.alignment = .trailing
            messageView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            messageImageView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

            messageTF.textColor = UIColor.white
            
            senderImage.sd_setImage(with: URL(string: userImage), placeholderImage: UIImage(named: "logo"))
            
        }else {
            chatView.alignment = .leading
            messageView.backgroundColor = UIColor.white
            messageImageView.backgroundColor = UIColor.white

            messageTF.textColor = UIColor.black
            
            senderImage.sd_setImage(with: URL(string: clientImage), placeholderImage: UIImage(named: "logo"))

        }
        
        if item.type == "message" {
            avatarMessageView.isHidden = false
            messageImageView.isHidden = true
            messageTF.text = item.message ?? ""
        }
        
        if item.type == "image" {
            avatarMessageView.isHidden = true
            messageImageView.isHidden = false
            
            let itemImage = item.image ?? ""
            
            if itemImage == "" {
                messageImage.image = item.sentImage
            }else {
                messageImage.sd_setImage(with: URL(string: SITE_URL + itemImage), placeholderImage: UIImage(named: "logo"))
            }
        }
    }

    
    

}
