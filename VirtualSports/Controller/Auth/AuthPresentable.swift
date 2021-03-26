//
//  AuthPresentable.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 22.03.2021.
//

import UIKit
import AuthService

protocol AuthPresentable: UIViewController {

    typealias Dependencies = HasAuthProvider

    var dependencies: Dependencies? { get set }

    var scrollView: UIScrollView? { get set }

    var primaryAction: (() -> Void)? { get set }
    var secondaryAction: (() -> Void)? { get set }
    var onClose: (() -> Void)? { get set }

}

class AuthBaseViewController: UIViewController, AuthPresentable {

    // MARK: - Variables

    var dependencies: Dependencies?

    // MARK: Outlets

    @IBOutlet weak var scrollView: UIScrollView?

    @IBOutlet weak var primaryButton: LoginButton?
    @IBOutlet weak var secondaryButton: LoginButton?
    @IBOutlet weak var closeButton: UIButton?

    // MARK: Completions

    var onComplete: (() -> Void)?
    var primaryAction: (() -> Void)?
    var secondaryAction: (() -> Void)?
    var onClose: (() -> Void)?

    var onValid: (() -> Void)?
    var onInvalid: (() -> Void)?

    // MARK: Private Variables

    private var additionValidations = [() -> Bool]()
    private var textFields = [UITextField]()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification,
                                selector: #selector(adjustForKeyboard))

        // Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(adjustForKeyboard))

        primaryButton?.addTarget(self, action: #selector(didTapPrimaryButton(_:)),
                                 for: .touchUpInside)

        secondaryButton?.addTarget(self, action: #selector(didTapSecondaryButton(_:)),
                                   for: .touchUpInside)

        closeButton?.addTarget(self, action: #selector(didTapCloseButton(_:)),
                                   for: .touchUpInside)
    }

    deinit {
        unsubscribeFromAllNotifications()
    }

}

private extension AuthBaseViewController {

    // MARK: - Actions

    @objc func didTapPrimaryButton(_ sender: Any) {
        primaryAction?()
    }

    @objc func didTapSecondaryButton(_ sender: Any) {
        secondaryAction?()
    }

    @objc func didTapCloseButton(_ sender: Any) {
        onClose?()
    }

}

extension AuthBaseViewController {

    // MARK: - Validations

    func appendTextFields(_ textFields: [UITextField?]) {

        self.textFields = textFields.compactMap { textField in
            textField?.delegate = self
            textField?.addTarget(self, action: #selector(validate), for: .editingChanged)

            return textField
        }

        self.textFields.enumerated().forEach { (index, textField) in
            textField.tag = index
        }

        self.textFields.first?.becomeFirstResponder()
    }

    func appendValidation(_ validation: @escaping () -> Bool) {
        additionValidations.append(validation)
    }

    @objc
    private func validate() {

        guard !textFields.contains(where: { $0.text?.isEmpty == true }) else {
            onInvalid?()
            return
        }

        guard !additionValidations.contains(where: { $0() == false }) else {
            onInvalid?()
            return
        }

        onValid?()
    }

    private func emptyValidation(textField: UITextField) -> Bool {
        !(textField.text?.isEmpty ?? false)
    }

}

extension AuthBaseViewController: UITextFieldDelegate {

    // MARK: - UITextField Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return false
    }

}

private extension AuthBaseViewController {

    // MARK: - Keyboard Handling

    func initializeHideKeyboard() {

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func adjustForKeyboard(notification: Notification) {

        guard let scrollView = scrollView else {
            return
        }

        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                                   right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

}
