//
//  LoginButton.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 22.03.2021.
//

import UIKit

@IBDesignable
final class LoginButton: UIButton {

    public func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled

        isEnabled ? setupWhenEnabled() : setup()

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
        layer.shadowColor = UIColor.white.cgColor

        backgroundColor = isEnabled ? .white : .init(white: 0.7, alpha: 1)
        alpha = isEnabled ? 1 : 0.3
    }

    internal func setupWhenEnabled() {
        backgroundColor = .yellow
        alpha = 1

        setupShadow()
    }

    internal func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10.0
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
    }

}
