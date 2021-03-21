//
//  TopBarView.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 20.03.2021.
//

import UIKit

@objc protocol TopBarDelegate: class {
    @objc func signInButtonPressed()
    @objc func logOutButtonPressed()
    @objc func signUpButtonPressed()
}
/*
 
 First: Setup your RootVC:
 
 1) Add TopBar as subview to root VC view and pin it to superView.top, safeArea.leading,
 safeArea.trailing, and fix height to 140.
 
 2) Make outlet from TopBarView to root VC
 
 3) Make topBar.delegate = self and and extend root VC with TopBarDelegate to manage user taps
 
 4) Implement follwing function
 
 
 override func viewWillAppear(_ animated: Bool) {
 self.navigationController?.setNavigationBarHidden(true, animated: animated)
 super.viewWillAppear(animated)
 }
 
 Second: In ChaildVC
 
 1) Implement follwing function
 
 
 override func viewWillAppear(_ animated: Bool) {
 self.navigationController?.setNavigationBarHidden(false, animated: animated)
 super.viewWillAppear(animated)
 }
 
 */

@IBDesignable
class TopBar: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var signUp: DesignableButton!
    @IBOutlet weak var signIn: DesignableButton!
    @IBOutlet weak var logOut: DesignableButton!

    weak var delegate: TopBarDelegate?

    var showLogOutButton = false {
        didSet {
            signIn.isHidden = !oldValue
            signUp.isHidden = !oldValue
            logOut.isHidden = oldValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        topBarSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        topBarSetup()
    }

    private func topBarSetup() {
        loadViewFromBundle()

        addSubview(contentView)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func loadViewFromBundle() {
        let bundle = Bundle(for: TopBar.self)
        bundle.loadNibNamed("TopBar", owner: self, options: nil)
    }

    // MARK: - @IBActions
    @IBAction func logoutButtonPressed(_ sender: DesignableButton) {
        delegate?.logOutButtonPressed()
    }

    @IBAction func loginButtonPressed(_ sender: DesignableButton) {
        delegate?.signInButtonPressed()
    }

    @IBAction func registerButtonPressed(_ sender: DesignableButton) {
        delegate?.signUpButtonPressed()
    }

}
