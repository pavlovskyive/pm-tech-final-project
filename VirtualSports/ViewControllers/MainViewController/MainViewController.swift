//
//  MainViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit

protocol MainViewControllerProtocol: BaseViewControllerProvider {
    var onGoToLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
    var onGoToGame: (() -> Void)? { get set }
}

class MainViewController: UIViewController, MainViewControllerProtocol {
    var onGoToLogin: (() -> Void)?
    var onGoToRegistration: (() -> Void)?
    var onGoToGame: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Actions

    @IBAction func didTapGame(_ sender: Any) {
        self.onGoToGame?()
    }

    @IBAction func didTapLoginButton(_ sender: Any) {
        self.onGoToLogin?()
    }

    @IBAction func didTapRegistrationButton(_ sender: Any) {
        self.onGoToRegistration?()
    }

}
