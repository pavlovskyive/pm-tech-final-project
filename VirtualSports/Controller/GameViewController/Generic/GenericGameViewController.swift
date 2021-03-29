//
//  GenericGameViewController.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 27.03.2021.
//

import UIKit
import APILayer
import WebKit

class GenericGameViewController: BaseGameViewController {

    @IBOutlet weak var webView: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: game.url) else {
            view.backgroundColor = UIColor(named: "Background")
            return
        }

        if dependencies?.authProvider.loggedIn ?? false {
            dependencies?.apiService.playMockedGame(gameId: game.id)
        }

        webView?.load(URLRequest(url: url))

        topBar?.showHistoryButton(dependencies?.authProvider.loggedIn ?? false)
    }

}
