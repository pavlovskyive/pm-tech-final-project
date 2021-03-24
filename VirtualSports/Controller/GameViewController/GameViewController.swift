//
//  GameViewController.swift
//  VirtualSports
//
//  Created by Вова Благой on 19.03.2021.
//

import UIKit

protocol GameViewControllerProtocol: AnyObject {

    var onGoToBack: (() -> Void)? { get set }
}

class GameViewController: UIViewController {

    @IBOutlet weak var topBar: TopBar!

    var onGoToBack: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.delegate = self
        topBar.showNextTopBar(name: "Name")

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
