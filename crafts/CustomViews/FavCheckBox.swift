//
//  FavCheckBox.swift
//  harajtarf
//
//  Created by AL Badr  on 1/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import UIKit

class FavCheckBox: UIButton {
    // Images heartblack
    let checkedImage = UIImage(named: "likered")! as UIImage
    let uncheckedImage = UIImage(named: "favouritegraay")! as UIImage
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        clipsToBounds = true
        
    }
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
      //  self.addTarget(self, action: Selector(("buttonClicked")), for: UIControlEvents.touchUpInside)
        self.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
