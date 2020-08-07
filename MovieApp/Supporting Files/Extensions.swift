//
//  Extensions.swift
//  MovieApp
//
//  Created by Rana Amer on 7/27/20.
//  Copyright © 2020 Hamza. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    @IBInspectable var borderWidth : CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor : UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? CGColor(srgbRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            layer.cornerRadius
        }
    }
}
