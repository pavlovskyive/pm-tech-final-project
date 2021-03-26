//
//  GameViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APILayer

protocol GameViewControllerProtocol: AnyObject {

    typealias Dependencies = HasAuthProvider & HasAPIFetching

    var dependencies: Dependencies? { get set }

    var onGoToBack: (() -> Void)? { get set }
}

class GameViewController: UIViewController {

    @IBOutlet weak var topBar: TopBar?

    var dependencies: Dependencies?
    let game: Game

    var onGoToBack: (() -> Void)?
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
        topBar?.delegate = self
        topBar?.showNextTopBar(name: game.name)

        topBar?.showFavoritesButton(dependencies?.authProvider.loggedIn ?? false)
        topBar?.setFavoritesButtonHighlighted(false)

        dependencies?.apiService.fetchFavourites { [weak self] result in
            switch result {
            case .success(let favourites):
                self?.isFavourite = favourites.contains(where: { $0.id == self?.game.id })
            case .failure(let error):
                print(error)
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

private extension GameViewController {

    func setFavourite(_ isFavourite: Bool) {
        if isFavourite {
            dependencies?.apiService
                .addFavorite(gameId: game.id, completion: handleFavouriteChangeResponce(error:))
        } else {
            dependencies?.apiService
                .removeFavorite(gameId: game.id, completion: handleFavouriteChangeResponce(error:))
        }
    }

    func handleFavouriteChangeResponce(error: APIError?) {
        guard let error = error else {
            self.isFavourite.toggle()
            return
        }

        print(error)
    }

}

extension GameViewController: TopBarDelegate {

    func backwardButtonPressed() {
        self.onGoToBack?()
    }

    func favoriteButtonPressed() {
        setFavourite(!isFavourite)
    }

}

extension GameViewController: GameViewControllerProtocol {

}
