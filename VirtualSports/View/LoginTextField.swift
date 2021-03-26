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

    var changeBottomLine: Bool = false {
        willSet {
            if newValue {
                bottomLine.backgroundColor = UIColor.red.withAlphaComponent(0.6).cgColor
            } else {
                bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorderFrame()
    }

    func setup() {
        setupBorderFrame()
        setupBorderStyle()
    }
    
    private func setupBorderStyle() {
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.6).cgColor
        borderStyle = .none
    }
    
    private func setupBorderFrame() {
        bottomLine.frame = CGRect(x: 0.0, y: frame.height + 10, width: frame.width, height: 1)
        
        layer.addSublayer(bottomLine)
    }
}

@IBDesignable
final class PasswordLoginTextField: LoginTextField {

    var visibilityButton = UIButton(type: .custom)

    override func setup() {
        super.setup()
        
        isSecureTextEntry = true
        setupVisibilityButton()
    }

    private func setupVisibilityButton() {

        visibilityButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        visibilityButton.contentHorizontalAlignment = .fill
        visibilityButton.contentVerticalAlignment = .fill
        visibilityButton.imageView?.contentMode = .scaleAspectFit
        
        visibilityButton.addTarget(self, action: #selector(didTapVisibilityButton), for: .touchUpInside)
        
        rightView = visibilityButton
        rightViewMode = .always
        updateVisibilityButton()
    }

    private func updateVisibilityButton() {

        if isSecureTextEntry {
            visibilityButton.setImage(UIImage(named: "EyeCrossed"), for: .normal)
            visibilityButton.alpha = 0.5
        } else {
            visibilityButton.setImage(UIImage(named: "Eye"), for: .normal)
            visibilityButton.alpha = 1
        }
    }

    @objc
    private func didTapVisibilityButton() {
        togglePasswordVisibility()
        updateVisibilityButton()
    }

}
