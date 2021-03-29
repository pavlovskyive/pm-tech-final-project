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
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let webView = webView else {
            return
        }

        webView.alpha = 0

        webView.navigationDelegate = self
        webView.uiDelegate = self

        view.addSubview(webView)

        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = self.view.center
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.style = .medium

        guard let activityIndicator = activityIndicator else {
            return
        }

        view.addSubview(activityIndicator)

        guard let url = URL(string: game.url) else {
            view.backgroundColor = UIColor(named: "Background")
            return
        }

        if dependencies?.authProvider.loggedIn ?? false {
            dependencies?.apiService.playMockedGame(gameId: game.id)
        }

        webView.load(URLRequest(url: url))

        topBar?.showHistoryButton(false)
    }

    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }

}

extension GenericGameViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
        UIView.animate(withDuration: 0.2) {
            self.webView?.alpha = 1
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
        UIView.animate(withDuration: 0.2) {
            self.webView?.alpha = 0
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
        UIView.animate(withDuration: 0.2) {
            self.webView?.alpha = 1
        }
    }

}
