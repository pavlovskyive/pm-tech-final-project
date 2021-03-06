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

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var emailTextField: LoginTextField?
    @IBOutlet weak var passwordTextField: LoginTextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailErrorLabel.isHidden = true

        let emailValidation = { [weak self] () -> Bool in

            guard let self = self else {
                return false
            }

            return self.checkEmail(emailTextField: self.emailTextField)
        }

        self.appendValidation(emailValidation)

        primaryAction = { [weak self] in

            self?.primaryButton?.setEnabled(false)

            guard let email = self?.emailTextField?.text,
                  let password = self?.passwordTextField?.text else {

                self?.primaryButton?.setEnabled(true)

                return
            }

            self?.dependencies?.authProvider.login(credentials: ["login": email, "password": password]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.onComplete?()
                    case .failure(let error):
                        let alert = Alert.errorAlert(title: "Ошибка авторизации", message: "Пользователь не найден или пароль не совпадает.")
                        DispatchQueue.main.async {
                            self?.present(alert, animated: true)
                        }
                        
                        log.error(error.localizedDescription)
                    }

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

        emailTextField?.addTarget(self, action: #selector(emailTextFieldEndEditing(_:)), for: .editingDidEnd)
    }

    private func checkEmail(emailTextField: UITextField?) -> Bool {

        guard let email = emailTextField?.text else {
            return false
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailPred.evaluate(with: email)
    }

    @objc func emailTextFieldEndEditing(_ textField: UITextField) {
        if checkEmail(emailTextField: emailTextField) {
            emailErrorLabel.isHidden = true
            emailTextField?.changeBottomLineColor = .green
            emailLabel.textColor = UIColor(named: "PMGreen")
        } else {
            emailErrorLabel.isHidden = false
            emailTextField?.changeBottomLineColor = .red
            emailLabel.textColor = .red
        }
    }

}
