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

    // MARK: - Private methods
    private func showMainVC() {

        let mainViewController = MainViewController()

        mainViewController.onGoToLogin = { [unowned self] in
            self.showLoginVC()
        }

        mainViewController.onGoToRegistration = { [unowned self] in
            self.showRegistrationVC()
        }

        mainViewController.onGoToGame = { [unowned self] in
            self.showGameVC()
        }
        self.router.setRootModule(mainViewController)
    }

    private func showLoginVC() {

        let loginViewController = LoginViewController()

        loginViewController.onGoToRegistration = { [unowned self] in
            self.showRegistrationVC()
        }

        loginViewController.didLogin = { [unowned self] in
            router.popToRootModule(animated: true)
        }

        if self.router.isInStack(controllerType: LoginViewController.self) {

            self.router.popModule()

        } else {

            self.router.push(loginViewController)
        }
    }

    private func showRegistrationVC() {

        let registrationViewController = RegistrationViewController()

        registrationViewController.onGoToLogin = { [unowned self] in
            self.showLoginVC()
        }

        registrationViewController.didRegister = { [unowned self] in
            router.popToRootModule(animated: true)
        }

        if self.router.isInStack(controllerType: RegistrationViewController.self) {

            self.router.popModule()
        } else {

            self.router.push(registrationViewController)
        }

    }

    private func showGameVC() {

        let gameViewController = GameViewController()

        self.router.push(gameViewController)

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
