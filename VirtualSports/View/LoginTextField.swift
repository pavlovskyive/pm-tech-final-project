//
//  LoginTextField.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 22.03.2021.
//

import UIKit

@IBDesignable
class LoginTextField: UITextField {

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
        setupBorder()
    }

    func setup() {
        setupBorder()
    }

    private func setupBorder() {
        bottomLine.frame = CGRect(x: 0.0, y: frame.height + 10, width: frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor

        borderStyle = .none
        layer.addSublayer(bottomLine)
    }

}

@IBDesignable
final class PasswordLoginTextField: LoginTextField {

    var button = UIButton(type: .custom)

    override func setup() {
        super.setup()

        isSecureTextEntry = true
        setupVisibilityButton()
    }

    private func setupVisibilityButton() {

        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit

        button.addTarget(self, action: #selector(didTapVisibilityButton), for: .touchUpInside)

        rightView = button
        rightViewMode = .always
        updateVisibilityButton()
    }

    private func updateVisibilityButton() {

        if isSecureTextEntry {
            button.setImage(UIImage(named: "EyeCrossed"), for: .normal)
            button.alpha = 0.5
        } else {
            button.setImage(UIImage(named: "Eye"), for: .normal)
            button.alpha = 1
        }
    }

    @objc
    private func didTapVisibilityButton() {
        togglePasswordVisibility()
        updateVisibilityButton()
    }

}
