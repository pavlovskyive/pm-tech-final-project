//
//  RegistrationViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit

class RegistrationViewController: AuthBaseViewController {

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
    @IBOutlet weak var confirmationTextField: LoginTextField?

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

            self?.authProvider.register(credentials: ["login": email, "password": password]) { error in
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
            passwordTextField,
            confirmationTextField
        ])

        let equalityValidation = { [weak self] in
            (self?.checkEquality(textFields: [self?.passwordTextField,
                                              self?.confirmationTextField]) ?? false)
        }

        appendValidation(equalityValidation)

        onValid = { [weak self] in
            self?.primaryButton?.setEnabled(true)
        }

        onInvalid = { [weak self] in
            self?.primaryButton?.setEnabled(false)
        }
    }

    private func checkEquality(textFields: [UITextField?]) -> Bool {
        let inputs = textFields.compactMap({ $0?.text })
        return inputs.dropFirst().allSatisfy({ $0 == inputs.first })
    }

}
