//
//  RoundButton.swift
//  harajtarf
//
//  Created by AL Badr  on 2/2/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedButton :UIButton {
    @IBInspectable var cornerRaduis: CGFloat = 1.0
    
    @IBInspectable var borderColor: UIColor = UIColor.white

    @IBInspectable var borderWidth: CGFloat = 1.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRaduis
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        clipsToBounds = true
    }
}
