//
//  RoundRectView.swift
//  JAK
//
//  Created by Zeinab Reda on 5/23/17.
//  Copyright © 2017 Zeinab Reda. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable class RoundRectView: UIView {
    let gradientLayer = CAGradientLayer()

    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradientView(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradientView(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
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
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
   
    
    public func setGradientView(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius

            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    public func removeGradientView() {
        gradientLayer.removeFromSuperlayer()
    }
}
