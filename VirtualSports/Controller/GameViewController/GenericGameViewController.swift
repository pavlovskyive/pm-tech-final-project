//
//  GenericGameViewController.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 27.03.2021.
//

import UIKit
import APILayer

class GenericGameViewController: BaseGameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        topBar?.showHistoryButton(dependencies?.authProvider.loggedIn ?? false)
    }

    override func handleBetOutcome(bet: Bet) {
        print(bet)
    }

    override func handleHistoryResponse(history: [Bet]) {
        print(history)
    }

}
