//
//  LoginButton.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 22.03.2021.
//

import UIKit

@IBDesignable
class LoginButton: UIButton {

    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        setup()
    }

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

    internal func setup() {

        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .heavy)

        setTitleColor(.black, for: .normal)

        layer.cornerRadius = 2

        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = isEnabled ? 1 : 0

        backgroundColor = isEnabled ? .white : .init(white: 0.7, alpha: 1)
        alpha = isEnabled ? 1 : 0.3
    }

}
