//
//  UIView + IBDesignable.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 20.03.2021.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        commonInit()
    }

    private func commonInit() {
        self.clipsToBounds = true
    }
}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
}
