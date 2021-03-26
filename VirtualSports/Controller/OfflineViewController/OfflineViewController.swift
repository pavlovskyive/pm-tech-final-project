//
//  OfflineViewController.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 26.03.2021.
//

import UIKit

protocol Dissmissable: AnyObject {
    var onGoToDissmiss: (() -> Void)? { get set }
}

final class OfflineViewController: UIViewController, Dissmissable {

    var onGoToDissmiss: (() -> Void)?

    @IBAction private func tryAgainButtonPressed(_ sender: DesignableButton) {

        if NetworkMonitor.shared.connectionState == .connected {
                DispatchQueue.main.async {
                    self.onGoToDissmiss?()
                }

            }
        }

    @IBAction private func offlineModeButtonPressed(_ sender: DesignableButton) {
        onGoToDissmiss?()
    }
}
