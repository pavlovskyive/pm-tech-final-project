//
//  GameViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APILayer
import AuthLayer

protocol GameViewControllable: AnyObject {

    typealias Dependencies = HasAuthProvider & HasAPIFetching

    var dependencies: Dependencies? { get set }

    var onGoToBack: (() -> Void)? { get set }
    var onGoToLogin: (() -> Void)? { get set }
    var onGoToHistory: (([Bet]) -> Void)? { get set }

    func makeBet(bet: Bet)
    func handleBetOutcome(bet: Bet)
    func handleHistoryResponse(history: [Bet])
}

class BaseGameViewController: UIViewController, GameViewControllable {

    @IBOutlet weak var topBar: TopBar?

    var dependencies: Dependencies?
    let game: Game

    var onGoToBack: (() -> Void)?
    var onGoToLogin: (() -> Void)?
    var onGoToHistory: (([Bet]) -> Void)?

    var isFavourite: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.topBar?.setFavoritesButtonHighlighted(self.isFavourite)
            }
        }
    }

    // MARK: Initialization

    init(for game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifcycle

    override func viewDidLoad() {

        super.viewDidLoad()

        topBar?.setGameNameLabel(text: game.name)
        topBar?.delegate = self
        topBar?.showGameTopBar(name: game.name)

        guard dependencies?.authProvider.loggedIn ?? false else {

            let alert = Alert.errorAlert(title: "Ошибка авторизации",
                                         message: "Пожалуйста войдите в систему!", needCancelButton: true) {
                DispatchQueue.main.async {
                    self.onGoToLogin?()
                }
            }

            self.present(alert, animated: true)

            log.info("User not logged in")
            return
        }

        topBar?.showFavoritesButton(true)
        topBar?.setFavoritesButtonHighlighted(false)

        checkFavourite()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func makeBet(bet: Bet) {
        dependencies?.apiService.playGame(gameId: game.id, bet: bet) { [weak self] result in
            switch result {
            case .success(let bet):
                DispatchQueue.main.async {
                    self?.handleBetOutcome(bet: bet)
                }
            case .failure(let error):
                let alert = Alert.errorAlert(title: "Ошибка ставки", message: "Ой... Что-то пошло не так.")

                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }

                log.error(error.localizedDescription)
            }
        }
    }

    func handleBetOutcome(bet: Bet) {
        // Must override
    }

    func handleHistoryResponse(history: [Bet]) {
        // Must override
    }

    func handleLogin() {
        topBar?.showHistoryButton(true)
        topBar?.showFavoritesButton(true)
        checkFavourite()
    }

    func handleLogout() {
        topBar?.showHistoryButton(false)
        topBar?.showFavoritesButton(false)
        checkFavourite()
    }

}

private extension BaseGameViewController {

    func setFavourite(_ isFavourite: Bool) {
        if isFavourite {
            dependencies?.apiService
                .addFavorite(gameId: game.id, completion: handleFavouriteChangeResponse(error:))
        } else {
            dependencies?.apiService
                .removeFavorite(gameId: game.id, completion: handleFavouriteChangeResponse(error:))
        }
    }

    func checkFavourite() {
        dependencies?.apiService.fetchFavourites { [weak self] result in
            switch result {
            case .success(let favourites):
                DispatchQueue.main.async {
                    self?.isFavourite = favourites.contains(where: { $0.id == self?.game.id })
                }
            case .failure(let error):
                log.error(error.localizedDescription)
            }
        }
    }

    func handleFavouriteChangeResponse(error: APIError?) {

        DispatchQueue.main.async { [weak self] in

            self?.topBar?.setEnableFavoritesButton(true)

            guard let error = error else {
                self?.isFavourite.toggle()
                return
            }

            log.error(error.localizedDescription)
        }
    }

}

extension BaseGameViewController: TopBarDelegate {

    func backwardButtonPressed() {
        self.onGoToBack?()
    }

    func favoriteButtonPressed() {
        topBar?.setEnableFavoritesButton(false)
        setFavourite(!isFavourite)
    }

    func historyButtonPressed() {

        dependencies?.apiService.fetchDiceHistory { [weak self] result in
            switch result {
            case .success(let bets):
                DispatchQueue.main.async {
                    self?.handleHistoryResponse(history: bets)
                }
            case .failure(let error):
                let alert = Alert.errorAlert(title: "Ошибка истории", message: "При загрузке истории что-то пошло не так.")

                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }

                log.error(error.localizedDescription)
            }
        }
    }

}
