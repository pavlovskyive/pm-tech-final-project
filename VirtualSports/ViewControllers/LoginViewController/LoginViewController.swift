//
//  LoginViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit

protocol LoginViewControllerProtocol: AnyObject {
    var didLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
}

class LoginViewController: UIViewController, LoginViewControllerProtocol {

    @IBOutlet weak var loginButton: LoginButton?
    @IBOutlet weak var registrationButton: LoginButton?

    var onGoToRegistration: (() -> Void)?
    var didLogin: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton?.setEnabled(false)
    }

    // MARK: Actions

    @IBAction func didTapRegistrationButton(_ sender: Any) {
        self.onGoToRegistration?()
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        self.didLogin?()
    }
}
