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

    @IBOutlet weak var passwordComplexityView: PasswordComplexityView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var matchPasswordsLabel: UILabel!
    @IBOutlet weak var validPasswordLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
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

            log.info("Sending registration request")
            self?.dependencies?.authProvider.register(credentials: ["login": email, "password": password]) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.onComplete?()
                    case .failure(let error):
                        log.error(error.localizedDescription)
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

        setupPasswordComplexityView()
        setupTextFieldsTarget()
        setupLabels()

    }

    private func setupPasswordComplexityView() {
        passwordComplexityView.isHidden = true
    }

    private func setupTextFieldsTarget() {
        passwordTextField?.addTarget(self, action: #selector(passwordTextFieldDidChange), for: .editingChanged)
        emailTextField?.addTarget(self, action: #selector(emailTextFieldEndEditing), for: .editingDidEnd)
    }

    private func setupLabels() {
        emailErrorLabel.isHidden = true
        matchPasswordsLabel.isHidden = true
        validPasswordLabel.isHidden = true
    }

    // MARK: Checks

    private func checkEquality(textFields: [UITextField?]) -> Bool {
        let inputs = textFields.compactMap({ $0?.text })
        let isSatisfy = inputs.dropFirst().allSatisfy({ $0 == inputs.first })

        if isSatisfy {
            confirmationTextField?.changeBottomLineColor = .green
        } else {
            confirmationTextField?.changeBottomLineColor = .red
        }

        matchPasswordsLabel.isHidden = isSatisfy

        return isSatisfy
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

        let lenghtCondition = checkPasswordLenghts(password)
        let lowercasesCondition = checkPasswordLowercases(password)
        let uppercasesCondition = checkPasswordUppercases(password)
        let numbersCondition = checkPasswordNumbersContains(password)

        let isSatisfy = lenghtCondition && lowercasesCondition && uppercasesCondition && numbersCondition

        return isSatisfy
    }

    private func checkPasswordLenghts(_ password: String) -> Bool {
        let isSatisfied = password.count >= 8

        passwordComplexityView.passwordLenghtsCondition = isSatisfied

        return isSatisfied
    }

    private func checkPasswordLowercases(_ password: String) -> Bool {

        let rule = ".*[a-z].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rule)
        let isSatisfied = predicate.evaluate(with: password)

        passwordComplexityView.lowercaseContainsCondition = isSatisfied

        return isSatisfied
    }

    private func checkPasswordUppercases(_ password: String) -> Bool {
        let rule = ".*[A-Z].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rule)
        let isSatisfied = predicate.evaluate(with: password)

        passwordComplexityView.uppercaseContainsCondition = isSatisfied

        return isSatisfied
    }

    private func checkPasswordNumbersContains(_ password: String) -> Bool {
        let rule = ".*[0-9].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", rule)
        let isSatisfied = predicate.evaluate(with: password)

        passwordComplexityView.numberContainsCondition = isSatisfied

        return isSatisfied
    }

    // MARK: TextFieldDidChange Actions

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

    @objc func passwordTextFieldDidChange(_ textField: UITextField) {
        guard let password = textField.text else {
            return
        }

        guard !password.isEmpty else {
            passwordComplexityView.resetConditions()
            passwordComplexityView.isHidden = false
            return
        }

        let lenght = checkPasswordLenghts(password)
        let lowercases = checkPasswordLowercases(password)
        let uppercases = checkPasswordUppercases(password)
        let numbers = checkPasswordNumbersContains(password)

        let conditions = lenght && lowercases && uppercases && numbers

        if conditions {
            validPasswordLabel.isHidden = false
            validPasswordLabel.text = "Валидный пароль"
            validPasswordLabel.textColor = UIColor(named: "PMGreen")
            
            passwordLabel.textColor = UIColor(named: "PMGreen")
            passwordTextField?.changeBottomLineColor = .green

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.passwordComplexityView.isHidden = true
            }

        } else {
            passwordComplexityView.isHidden = false
            passwordLabel.textColor = .red
            passwordTextField?.changeBottomLineColor = .red
           
            validPasswordLabel.isHidden = false
            validPasswordLabel.text = "Невалидный пароль"
            validPasswordLabel.textColor = .red
            
        }

    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = super.textFieldShouldReturn(textField)
        
        passwordComplexityView.isHidden = true
        
        return false
    }

}
