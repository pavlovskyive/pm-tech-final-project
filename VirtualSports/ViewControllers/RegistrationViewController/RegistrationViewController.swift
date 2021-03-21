//
//  RegistrationViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit

protocol RegistrationViewControllerProtocol: AnyObject {
    var didRegister: (() -> Void)? { get set }
    var onGoToLogin: (() -> Void)? { get set }
}

class RegistrationViewController: UIViewController, RegistrationViewControllerProtocol {
    var onGoToLogin: (() -> Void)?
    var didRegister: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Actions

    @IBAction func didTapRegisterButton(_ sender: Any) {
        self.didRegister?()
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        self.onGoToLogin?()
    }

}
