//
//  GameViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit
import APIService

protocol GameViewControllerProtocol: AnyObject {

    var onGoToBack: (() -> Void)? { get set }
}

class GameViewController: UIViewController {

    @IBOutlet weak var topBar: TopBar!

    let game: Game

    var onGoToBack: (() -> Void)?

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
        topBar.delegate = self
        topBar.showNextTopBar(name: game.name)

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension GameViewController: TopBarDelegate {
    func signInButtonPressed() {

    }

    func logOutButtonPressed() {

    }

    func signUpButtonPressed() {

    }

    func backwardButtonPressed() {
        self.onGoToBack?()
    }

}

extension GameViewController: GameViewControllerProtocol {

}
