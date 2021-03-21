//
//  UIView + IBDesignable.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 20.03.2021.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
}
