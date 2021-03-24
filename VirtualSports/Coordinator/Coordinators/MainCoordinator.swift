//
//  MainCoordinator.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

import APIService

final class MainCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    // MARK: - CoordinatorFinishOutput
    var finishFlow: (() -> Void)?
    
    // MARK: - Vars & Lets
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol
    private var onLoggedIn: (() -> Void)?
    
    // MARK: - Private methods
    private func showMainVC() {
        
        let mainViewController = MainViewController()
        
        onLoggedIn = {
            mainViewController.loggedIn()
        }
        
        mainViewController.onGoToLogin = { [unowned self] in
            self.showLoginVC()
        }
        
        mainViewController.onGoToRegistration = { [unowned self] in
            self.showRegistrationVC()
        }
        
        mainViewController.onGoToGame = { [unowned self] game in
            self.showGameVC(for: game)
        }
        
        mainViewController.onGoToFilter = { [unowned self] mainResponse in
            self.showFilterVC(for: mainResponse)
        }
        
        self.router.setRootModule(mainViewController, hideBar: true)
    }
    
    private func showLoginVC() {
        
        let loginViewController = LoginViewController()
        
        loginViewController.onComplete = { [unowned self] in
            self.router.dismissModule()
            onLoggedIn?()
        }
        
        loginViewController.secondaryAction = { [unowned self] in
            self.router.dismissModule()
            showRegistrationVC()
        }
        
        loginViewController.onClose = { [unowned self] in
            self.router.dismissModule()
        }
        
        router.present(loginViewController)
    }
    
    private func showRegistrationVC() {
        
        let registrationViewController = RegistrationViewController()
        
        registrationViewController.onComplete = { [unowned self] in
            self.router.dismissModule()
            onLoggedIn?()
        }
        
        registrationViewController.secondaryAction = { [unowned self] in
            self.router.dismissModule()
            showLoginVC()
        }
        
        registrationViewController.onClose = { [unowned self] in
            self.router.dismissModule()
        }
        
        self.router.present(registrationViewController)
        
    }
    
    private func showGameVC(for game: Game?) {
        guard let game = game else { return }
        
        let gameViewController = GameViewController(for: game)
        
        gameViewController.onGoToBack = { [unowned self] in
            self.router.popModule()
        }
        
        self.router.push(gameViewController)
        
    }
    
    private func showFilterVC(for mainResponse: MainResponse?) {
        guard let mainResponse = mainResponse else { return }
        
        let filterViewController = FilterViewController(for: mainResponse)
        
        filterViewController.onGoToDismiss = { [unowned self] in
            self.router.dismissModule()
        }
        
        self.router.present(filterViewController)
    }
    
    // MARK: - Coordinator
    override func start() {
        self.showMainVC()
    }
    
    // MARK: - Init
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
}
