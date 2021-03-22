//
//  LoginViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit

class LoginViewController: AuthBaseViewController {

    @IBOutlet override weak var scrollView: UIScrollView? {
        get {
            super.scrollView
        }
        set {
            super.scrollView = newValue
        }
    }

    @IBOutlet override weak var primaryButton: LoginButton? {
        get {
            super.primaryButton
        }
        set {
            super.primaryButton = newValue
        }
    }

    @IBOutlet override weak var secondaryButton: LoginButton? {
        get {
            super.secondaryButton
        }
        set {
            super.secondaryButton = newValue
        }
    }

    @IBOutlet override weak var closeButton: UIButton? {
        get {
            super.closeButton
        }
        set {
            super.closeButton = newValue
        }
    }

    @IBOutlet weak var emailTextField: LoginTextField?
    @IBOutlet weak var passwordTextField: LoginTextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        let textFields = [
            emailTextField,
            passwordTextField
        ]

        textFields.enumerated().forEach { (index, textField) in
            textField?.delegate = self
            textField?.tag = index + 1
        }
    }

}
