//
//  TopBarView.swift
//  VirtualSports
//
//  Created by Alexandr Sopilnyak on 20.03.2021.
//

import UIKit

protocol TopBarDelegate: AnyObject {

    func signInButtonPressed()
    func logOutButtonPressed()
    func signUpButtonPressed()
    func backwardButtonPressed()
    func favoriteButtonPressed()
}

extension TopBarDelegate {

    func signInButtonPressed() {}
    func logOutButtonPressed() {}
    func signUpButtonPressed() {}
    func backwardButtonPressed() {}
    func favoriteButtonPressed() {}
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
    @IBOutlet weak var signUp: DesignableButton?
    @IBOutlet weak var signIn: DesignableButton?
    @IBOutlet weak var logOut: DesignableButton?
    @IBOutlet weak var backwardButton: UIButton?
    @IBOutlet weak var logoView: UIImageView?
    @IBOutlet weak var gameNameLabel: UILabel?
    @IBOutlet weak var favoritesButton: UIButton?

    weak var delegate: TopBarDelegate?

    private lazy var allItems = [
        signIn,
        signUp,
        logOut,
        backwardButton,
        logoView,
        gameNameLabel,
        favoritesButton
    ]

    func showLogOutButton() {

        let visibleItems = [
            logOut,
            logoView
        ]

        showOnly(visibleItems)
    }

    func showNextTopBar(name: String) {

        let visibleItems = [
            backwardButton,
            gameNameLabel
        ]

        showOnly(visibleItems)
    }

    func showMainTopBar() {

        let visibleItems = [
            signIn,
            signUp,
            logoView
        ]

        showOnly(visibleItems)
    }

    func setFavoritesButtonHighlighted(_ isHightlighted: Bool) {
        favoritesButton?.alpha = isHightlighted ? 1 : 0.2
    }

    func showFavoritesButton(_ show: Bool) {
        favoritesButton?.isHidden = !show
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

    private func showOnly(_ visible: [UIView?]) {

        visible.forEach({ $0?.isHidden = false })

        allItems
            .filter({ !visible.contains($0) })
            .forEach({ $0?.isHidden = true })
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

    @IBAction func backwardButtonPressed(_ sender: Any) {
        delegate?.backwardButtonPressed()
    }

    @IBAction func favouritesButtonPressed(_ sender: Any) {
        delegate?.favoriteButtonPressed()
    }

}
