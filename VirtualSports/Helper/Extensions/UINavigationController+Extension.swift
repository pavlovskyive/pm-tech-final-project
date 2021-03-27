//
//  UINavigationController+Extension.swift
//  VirtualSports
//
//  Created by Вова Благой on 27.03.2021.
//

import UIKit

extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {

        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
