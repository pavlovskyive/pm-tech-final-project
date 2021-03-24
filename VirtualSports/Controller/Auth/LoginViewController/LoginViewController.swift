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
        
        primaryAction = { [weak self] in
            
            self?.primaryButton?.setEnabled(false)
            
            guard let email = self?.emailTextField?.text,
                  let password = self?.passwordTextField?.text else {

                DispatchQueue.main.async {
                    self?.primaryButton?.setEnabled(true)
                }

                return
            }

            self?.authProvider.login(credentials: ["login": email, "password": password]) { error in
                guard let error = error else {
                    DispatchQueue.main.async {
                        self?.onComplete?()
                    }
                    return
                }
                
                print(error)
                
                DispatchQueue.main.async {
                    self?.primaryButton?.setEnabled(true)
                }
            }
        }

        primaryButton?.setEnabled(false)

        appendTextFields([
            emailTextField,
            passwordTextField
        ])

        onValid = { [weak self] in
            self?.primaryButton?.setEnabled(true)
        }

        onInvalid = { [weak self] in
            self?.primaryButton?.setEnabled(false)
        }
    }

}
