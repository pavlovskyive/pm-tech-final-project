//
//  Alert.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 28.03.2021.
//

import UIKit

public struct Alert {

    static func errorAlert(title: String, message: String, needCancelButton: Bool = false, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let completion = completion else { return }
            completion()
        }

        alert.addAction(okAction)
        if needCancelButton {
            alert.addAction(cancelAction)
        }

        return alert
    }
}
