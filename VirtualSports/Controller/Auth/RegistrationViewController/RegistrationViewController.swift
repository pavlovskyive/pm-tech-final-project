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

                self?.primaryButton?.setEnabled(true)

                return
            }

            self?.dependencies?.authProvider.register(credentials: ["login": email, "password": password]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.onComplete?()
                    case .failure(let error):
                        print(error)
                    }

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

        let equalityValidation = { [weak self] () -> Bool in

            guard let self = self else {
                return false
            }

            return self.checkEquality(textFields: [self.passwordTextField, self.confirmationTextField])
        }

        let emailValidation = { [weak self] () -> Bool in

            guard let self = self else {
                return false
            }

            return self.checkEmail(emailTextField: self.emailTextField)
        }

        let complexityValidation = { [weak self] () -> Bool in

            guard let self = self else {
                return false
            }

            return self.checkPasswordRequirements(passwordTextField: self.passwordTextField)
        }

        appendValidation(equalityValidation)
        appendValidation(emailValidation)
        appendValidation(complexityValidation)

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

    private func checkEmail(emailTextField: UITextField?) -> Bool {

        guard let email = emailTextField?.text else {
            return false
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailPredicate.evaluate(with: email)
    }

    private func checkPasswordRequirements(passwordTextField: UITextField?) -> Bool {

        guard let password = passwordTextField?.text else {
            return false
        }

        let passwordRegEx = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", passwordRegEx)

        return passwordPredicate.evaluate(with: password)
    }

}
