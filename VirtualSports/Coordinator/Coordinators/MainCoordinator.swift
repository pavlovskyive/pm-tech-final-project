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

    private func showMainVC() {

        log.info("Show MainViewController")

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

        log.info("Show LoginViewController")

        let loginViewController = LoginViewController()
        loginViewController.dependencies = dependencies

        loginViewController.onComplete = { [unowned self] in
            self.router.dismissModule()
        }

        loginViewController.secondaryAction = { [unowned self] in
            self.router.dismissModule()
            self.showRegistrationVC()
        }

        loginViewController.onClose = { [unowned self] in
            self.router.dismissModule()
        }

        router.present(loginViewController)
    }

    private func showRegistrationVC() {

        log.info("Show RegistrationViewController")

        let registrationViewController = RegistrationViewController()

        registrationViewController.dependencies = dependencies

        registrationViewController.onComplete = { [unowned self] in
            self.router.dismissModule()
        }

        registrationViewController.secondaryAction = { [unowned self] in
            self.router.dismissModule()
            self.showLoginVC()
        }

        registrationViewController.onClose = { [unowned self] in
            self.router.dismissModule()
        }

        self.router.present(registrationViewController)

    }

    private func showGameVC(for game: Game?) {

        log.info("Show GameViewController")

        guard let game = game else { return }

        let gameViewController: BaseGameViewController

        switch game.id {
        case "original_dice_game":
            gameViewController = DiceGameViewController(for: game)
        default:
            gameViewController = GenericGameViewController(for: game)
        }

        gameViewController.dependencies = dependencies
        gameViewController.onGoToLogin = { [unowned self] in
            showLoginVC()
        }

        gameViewController.onGoToBack = { [unowned self] in
            router.popModule()
        }

        gameViewController.onGoToHistory = { [unowned self] bets in
            showBetsHistory(bets: bets)
        }

        self.router.push(gameViewController)
    }

    private func showFilterVC(for mainResponse: MainResponse?, delegate: FilterDelegate) {

        log.info("Show FilterViewController")

        guard let mainResponse = mainResponse else { return }

        let filterViewController = FilterViewController(for: mainResponse, delegate: delegate)

        filterViewController.onGoToDismiss = { [unowned self] in
            self.router.dismissModule()
        }

        self.router.present(filterViewController)
    }

    private func showOfflineVC() {

        log.info("Show OfflineViewController")

        let offlineViewController = OfflineViewController()

        offlineViewController.onGoToDissmiss = {
            self.router.popToRootModule(animated: true)
        }

        router.push(offlineViewController)

    }

    private func showBetsHistory(bets: [Bet]) {

        log.info("Showing bets history")

        let betsHistoryViewController = BetsHistoryViewController(bets: bets)

        betsHistoryViewController.onDismiss = {
            self.router.dismissModule()
        }

        router.present(betsHistoryViewController)

    }

    // MARK: - Coordinator
    override func start() {

        log.info("Main flow started")
        self.showMainVC()
    }

    // MARK: - Init
    init(router: RouterProtocol, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

}
