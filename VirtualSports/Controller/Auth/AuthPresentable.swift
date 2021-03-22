//
//  AuthPresentable.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 22.03.2021.
//

import UIKit

protocol AuthPresentable: UIViewController {

    var scrollView: UIScrollView? { get set }

    var primaryAction: (() -> Void)? { get set }
    var secondaryAction: (() -> Void)? { get set }
    var onClose: (() -> Void)? { get set }

}

class AuthBaseViewController: UIViewController, AuthPresentable {

    @IBOutlet weak var scrollView: UIScrollView?

    @IBOutlet weak var primaryButton: LoginButton?
    @IBOutlet weak var secondaryButton: LoginButton?
    @IBOutlet weak var closeButton: UIButton?

    var primaryAction: (() -> Void)?
    var secondaryAction: (() -> Void)?
    var onClose: (() -> Void)?

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

    func initializeHideKeyboard() {

        // Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))

        // Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {

        // endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        // In short- Dismiss the active keyboard.
        view.endEditing(true)
    }

}

extension AuthBaseViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        // Check if there is any other text-field in the view whose tag is +1 greater than the current text-field
        // on which the return key was pressed. If yes → then move the cursor to that next text-field.
        // If No → Dismiss the keyboard
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }

}

extension AuthBaseViewController {

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
