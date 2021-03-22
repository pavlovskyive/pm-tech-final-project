//
//  LoginTextField.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 22.03.2021.
//

import UIKit

@IBDesignable
final class LoginTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    let bottomLine = CALayer()

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    internal func setup() {

        bottomLine.frame = CGRect(x: 0.0, y: frame.height + 10, width: frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor

        borderStyle = .none
        layer.addSublayer(bottomLine)
    }

}
