//
//  CircleImage.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
         didSet {
             self.layer.borderColor = borderColor.cgColor
         }
     }

     @IBInspectable var borderWidth: CGFloat = 2.0 {
         didSet {
             self.layer.borderWidth = borderWidth
         }
     }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        clipsToBounds = true
    }
}
