//
//  MainViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APIService
import KeychainWrapper

protocol MainViewControllerProtocol: BaseViewControllerProvider {

    var onGoToLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
    var onGoToGame: (() -> Void)? { get set }
    var onGoToFilter: (() -> Void)? { get set }

    func loggedIn()
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

        fetchMain()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Actions

    @IBAction private func didTapGame(_ sender: Any) {
        self.onGoToGame?()
    }

    private func fetchMain() {
        apiService.fetchMain { result in
            switch result {
            case .success(let mainResponse):
                print(mainResponse)
            case .failure(let error):
                print(error)
            }
        }
    }

    func loggedIn() {
        guard let token = try? KeychainWrapper().get(forKey: "token") else {
            // Handle token somehow not installed
            print("Something went wrong...")
            return
        }
        
        apiService.token = token
        fetchMain()
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
