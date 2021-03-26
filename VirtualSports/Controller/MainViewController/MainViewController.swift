//
//  MainViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APIService
import KeychainWrapper

import Network

protocol MainViewControllerProtocol: BaseViewControllerProvider {
    
    var onGoToLogin: (() -> Void)? { get set }
    var onGoToRegistration: (() -> Void)? { get set }
    var onGoToGame: ((_ game: Game?) -> Void)? { get set }
    var onGoToFilter: ((_ mainResponse: MainResponse?) -> Void)? { get set }
    var onGoToOffline: (() -> Void)? { get set }
    
    func loggedIn()
}

class MainViewController: UIViewController, MainViewControllerProtocol {
    
    lazy var apiService: APIFetcher = {
        return APIService(config: apiConfig)
    }()
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Actions
    
    @IBAction private func didTapGame(_ sender: Any) {
        #warning("Game mock - replace for using with actual data.")
        self.onGoToGame?(Game(id: "123", provider: "123", categories: ["123"], name: "123", tags: ["123"]))
    }
    
    private func fetchMain() {
        apiService.fetchMain { result in
            switch result {
            case .success(let mainResponse):
                print(mainResponse)
                self.mainResponse = mainResponse
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
        #warning("replace for using with actual data.")
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
        
    }
    
    func signUpButtonPressed() {
        
        self.onGoToRegistration?()
    }
}
