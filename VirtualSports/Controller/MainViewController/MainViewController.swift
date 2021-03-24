//
//  MainViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APIService
import NetworkService

protocol MainViewControllerProtocol: BaseViewControllerProvider {

    var onGoToLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
    var onGoToGame: (() -> Void)? { get set }
    var onGoToFilter: (() -> Void)? { get set }
}

class MainViewController: UIViewController, MainViewControllerProtocol {

    lazy var apiService: APIFetcher = {
        return APIService(config: apiConfig)
    }()

    var onGoToLogin: (() -> Void)?
    var onGoToRegistration: (() -> Void)?
    var onGoToGame: (() -> Void)?
    var onGoToFilter: (() -> Void)?

    @IBOutlet private weak var topBar: TopBar!
    @IBOutlet private weak var filterButtonView: FilterButtonView!

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButtonView.delegate = self
        topBar.delegate = self
        topBar.showMainTopBar()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Actions

    @IBAction private func didTapGame(_ sender: Any) {
        self.onGoToGame?()
    }

}

extension MainViewController: FilterButtonDelegate {

    func didTapFilterButton() {
        self.onGoToFilter?()
        print("Filter button pressed")
    }

}

extension MainViewController: TopBarDelegate {

    func backwardButtonPressed() {

    }

    func signInButtonPressed() {

        self.onGoToLogin?()
    }

    func logOutButtonPressed() {

    }

    func signUpButtonPressed() {

        self.onGoToRegistration?()
    }

}
