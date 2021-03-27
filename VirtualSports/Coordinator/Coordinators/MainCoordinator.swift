//
//  MainCoordinator.swift
//  VirtualSports
//
//  Created by Вова Благой on 21.03.2021.
//

import APILayer

final class MainCoordinator: BaseCoordinator, CoordinatorFinishOutput {

    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?

    // MARK: - Vars & Lets

    var dependencies: AppDependency?
    private let router: RouterProtocol
    private let coordinatorFactory: CoordinatorFactoryProtocol

    // MARK: - Private methods

    @available(iOS 13.0, *)
    private func showMainVC() {

        let mainViewController = MainViewController()

        mainViewController.dependencies = dependencies

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
            self.showFilterVC(for: mainResponse, delegate: mainViewController)
        }

        mainViewController.onGoToOffline = { [unowned self] in
            self.showOfflineVC()
        }

        self.router.setRootModule(mainViewController, hideBar: true)
    }

    private func showLoginVC() {

        let loginViewController = LoginViewController()
        loginViewController.dependencies = dependencies

        loginViewController.onComplete = { [unowned self] in
            router.dismissModule()
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

        registrationViewController.dependencies = dependencies

        registrationViewController.onComplete = { [unowned self] in
            router.dismissModule()
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

    private func showGameVC(for game: Game?) {

        guard let game = game else { return }

        let gameViewController = GameViewController(for: game)

        gameViewController.dependencies = dependencies

        gameViewController.onGoToBack = { [unowned self] in
            router.popModule()
        }

        self.router.push(gameViewController)

    }

    private func showFilterVC(for mainResponse: MainResponse?, delegate: FilterDelegate) {
        guard let mainResponse = mainResponse else { return }

        let filterViewController = FilterViewController(for: mainResponse, delegate: delegate)

        filterViewController.onGoToDismiss = { [unowned self] in
            self.router.dismissModule()
        }

        self.router.present(filterViewController)
    }

    private func showOfflineVC() {
        let offlineViewController = OfflineViewController()

        offlineViewController.onGoToDissmiss = {
            self.router.popToRootModule(animated: true)
        }

        router.push(offlineViewController)

    }

    // MARK: - Coordinator
    override func start() {
        if #available(iOS 13.0, *) {
            self.showMainVC()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Init
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

}
