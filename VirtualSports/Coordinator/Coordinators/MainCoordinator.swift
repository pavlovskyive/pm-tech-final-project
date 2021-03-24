//
//  MainCoordinator.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

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

        mainViewController.onGoToGame = { [unowned self] in
            self.showGameVC()
        }

        mainViewController.onGoToFilter = { [unowned self] in
            self.showFilterVC()
        }

        self.router.setRootModule(mainViewController, hideBar: true)
    }

    private func showLoginVC() {

        let loginViewController = LoginViewController()

        loginViewController.onComplete = { [unowned self] in
            router.dismissModule()
            onLoggedIn?()
        }

        loginViewController.secondaryAction = { [unowned self] in
            router.dismissModule()
            showRegistrationVC()
        }

        loginViewController.onClose = { [unowned self] in
            router.dismissModule()
        }

        router.present(loginViewController)
    }

    private func showRegistrationVC() {

        let registrationViewController = RegistrationViewController()

        registrationViewController.onComplete = { [unowned self] in
            router.dismissModule()
            onLoggedIn?()
        }

        registrationViewController.secondaryAction = { [unowned self] in
            router.dismissModule()
            showLoginVC()
        }

        registrationViewController.onClose = { [unowned self] in
            router.dismissModule()
        }

        self.router.present(registrationViewController)

    }

    private func showGameVC() {

        let gameViewController = GameViewController()

        gameViewController.onGoToBack = { [unowned self] in
            router.popModule()
        }

        self.router.push(gameViewController)

    }

    private func showFilterVC() {
        let filterViewController = FilterViewController()

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
