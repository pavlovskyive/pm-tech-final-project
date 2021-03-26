//
//  MainViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APIService
import AuthService

import Network

protocol MainViewControllerProtocol: BaseViewControllerProvider {

    typealias Dependencies = HasAuthProvider & HasAPIFetching

    var dependencies: Dependencies? { get set }

    var onGoToLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
    var onGoToGame: ((_ game: Game?) -> Void)? { get set }
    var onGoToFilter: ((_ mainResponse: MainResponse?) -> Void)? { get set }
    var onGoToOffline: (() -> Void)? { get set }
    
}

class MainViewController: UIViewController, MainViewControllerProtocol {

    var dependencies: Dependencies?

    var mainResponse: MainResponse?

    var onGoToLogin: (() -> Void)?
    var onGoToRegistration: (() -> Void)?
    var onGoToGame: ((_ game: Game?) -> Void)?
    var onGoToFilter: ((_ mainResponse: MainResponse?) -> Void)?
    var onGoToOffline: (() -> Void)?
    
    var connectionState = NetworkMonitor.shared.connectionState {
        willSet {
            checkNetworkConnectionState(newValue)
        }
    }
    
    @IBOutlet private weak var topBar: TopBar!
    @IBOutlet private weak var filterButtonView: FilterButtonView!

    override func viewDidLoad() {
        super.viewDidLoad()
        filterButtonView.delegate = self
        topBar.delegate = self
        topBar.showMainTopBar()
        checkNetworkConnectionState(connectionState)
        
    }
    
    private func checkNetworkConnectionState(_ state: ConnectionState) {
        switch state {
        case .connected:
        dependencies?.authProvider.subscribe(self)
            fetchMain()
        case .disconnected:
            DispatchQueue.main.async {
                self.onGoToOffline?()
            }
        }
        
        NetworkMonitor.shared.handleConnection = { [weak self] isConnected in
            guard let self = self else { return }
            self.connectionState = isConnected
        }
    }

    deinit {
        dependencies?.authProvider.unsubscribe(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Actions
    
    @IBAction private func didTapGame(_ sender: Any) {

        // TODO: Game mock - replace for using with actual data.
        self.onGoToGame?(Game(id: "123", provider: "123", categories: ["123"], name: "123", tags: ["123"]))
    }

    private func fetchMain() {
        dependencies?.apiService.fetchMain { result in
            switch result {
            case .success(let mainResponse):
                print(mainResponse)
                self.mainResponse = mainResponse
            case .failure(let error):
                print(error)
            }
        }
    }

    private func logout() {
        dependencies?.authProvider.logout { error in
            guard let error = error else {
                return
            }

            print(error)
        }
    }

}

extension MainViewController: AuthDelegate {

    func onLogin() {
        DispatchQueue.main.async {
            self.topBar.showLogOutButton = true
        }

        fetchMain()
    }

    func onLogout() {
        DispatchQueue.main.async {
            self.topBar.showLogOutButton = false
            self.topBar.showMainTopBar()
        }
    }
    
}

extension MainViewController: FilterButtonDelegate {

    func didTapFilterButton() {
        self.onGoToFilter?(mainResponse)
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
        logout()
    }

    func signUpButtonPressed() {

        self.onGoToRegistration?()
    }

}

