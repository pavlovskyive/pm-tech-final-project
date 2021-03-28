//
//  DiceGameViewController.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 27.03.2021.
//

import UIKit
import APILayer
import AuthLayer

fileprivate extension Bet {

    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"

        return dateFormatter
    }()

    init(betType: Int) {
        let dateString = Bet.dateFormatter.string(from: Date())
        self.init(dateTime: dateString, betType: betType)
    }

}

class BetButton: UIButton {
    var outcome: String = ""
    var betType: Int?
}

class DiceGameViewController: BaseGameViewController {

    private var currentBetType: Int? {
        didSet {
            checkConfirmationButtonEnabled()
        }
    }

    private var currentBetOutcome: String = "" {
        didSet {
            setChosenBetLabel(outcome: currentBetOutcome)
        }
    }

    @IBOutlet weak var chosenBetLabel: UILabel?
    @IBOutlet weak var onUnauthorizedView: UIStackView?
    @IBOutlet weak var resultingDiceImageView: UIImageView?

    @IBOutlet weak var additionalBetButtons: UIStackView?
    @IBOutlet weak var leftStackView: UIStackView?
    @IBOutlet weak var rightStackView: UIStackView?

    @IBOutlet weak var confirmationButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        dependencies?.authProvider.subscribe(self)

        setupButtons()
        checkAuth()

        topBar?.showHistoryButton(dependencies?.authProvider.loggedIn ?? false)
    }

    override func handleHistoryResponse(history: [Bet]) {
        onGoToHistory?(history)
    }

    override func handleLogin() {
        super.handleLogin()

        checkAuth()
    }

    override func handleLogout() {
        super.handleLogout()

        checkAuth()
    }

    @IBAction func onLoginButtonTapped(_ sender: Any) {
        log.info("Login button tapped")
        onGoToLogin?()
    }

    @IBAction func onConfirmButtonTapped(_ sender: Any) {

        log.info("Confirm button tapped")

        guard let betType = currentBetType else {
            return
        }

        currentBetType = nil
        checkConfirmationButtonEnabled()

        let bet = Bet(betType: betType)

        dependencies?.apiService.playGame(gameId: "dice", bet: bet) { [weak self] result in
            switch result {
            case .success(let bet):
                DispatchQueue.main.async {
                    self?.checkConfirmationButtonEnabled()
                    self?.handleBetResult(bet: bet)
                }
            case .failure(let error):
                let alert = Alert.errorAlert(title: "Game error", message: error.localizedDescription)

                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }

                log.error(error.localizedDescription)
            }
        }
    }
}

extension DiceGameViewController: AuthDelegate {

    func onLogin() {
        DispatchQueue.main.async {
            super.handleLogin()
            self.checkAuth()
        }
    }

    func onLogout() {
        DispatchQueue.main.async {
            super.handleLogout()
            self.checkAuth()
        }
    }

}

private extension DiceGameViewController {

    func setupButtons() {

        for number in 1...6 {
            let button = BetButton(type: .system)

            configDiceButton(button, number: number)

            let stack = number > 3 ? rightStackView : leftStackView
            stack?.addArrangedSubview(button)
        }

        let evenButton = BetButton(type: .system)
        let oddButton = BetButton(type: .system)

        configAdditionalDiceButton(evenButton, isOdd: false)
        configAdditionalDiceButton(oddButton, isOdd: true)

        additionalBetButtons?.addArrangedSubview(evenButton)
        additionalBetButtons?.addArrangedSubview(oddButton)
    }

    func configDiceButton(_ button: BetButton, number: Int) {

        button.setTitle("ИСХОД: \(number)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)

        button.betType = number - 1
        button.outcome = "\(number)"
        button.addTarget(self, action: #selector(handleBetButtonTapped(_:)),
                         for: .touchUpInside)

        let image = UIImage(named: "dice\(number)")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        button.addSubview(imageView)
    }

    func configAdditionalDiceButton(_ button: BetButton, isOdd: Bool) {

        let outcome = "\(isOdd ? "НЕЧЁТ" : "ЧЁТ")"
        button.setTitle("ИСХОД: \(outcome)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 35 * 3 + 5, bottom: 0, right: 0)

        let betType = isOdd ? 7 : 6
        button.betType = betType
        button.outcome = outcome

        button.addTarget(self, action: #selector(handleBetButtonTapped(_:)),
                         for: .touchUpInside)

        for number in 1...6 {

            guard isOdd == (number % 2 != 0) else {
                continue
            }

            let image = UIImage(named: "dice\(number)")
            let imageView = UIImageView(image: image)
            imageView.tintColor = .white

            imageView.frame = CGRect(x: 35 * floor(Double((number - 1) / 2)),
                                     y: 0, width: 30, height: 30)

            button.addSubview(imageView)
        }
    }

    @objc func handleBetButtonTapped(_ sender: BetButton) {

        log.info("Bet button tapped")

        guard let betType = sender.betType else {
            return
        }

        currentBetType = betType
        currentBetOutcome = sender.outcome
    }

    func setChosenBetLabel(outcome: String) {
        chosenBetLabel?.text = "ВЫБРАННЫЙ ИСХОД: " + outcome
    }

    func setResultBetLabel(didWin: Bool) {
        chosenBetLabel?.text = "РЕЗУЛЬТАТ: " + (didWin ? "ПОБЕДА" : "ПОРАЖЕНИЕ")
    }

    func checkConfirmationButtonEnabled() {
        let emptyBetCondition = currentBetType != nil
        let loggedInCondition = dependencies?.authProvider.loggedIn ?? false
        let isEnabled = emptyBetCondition && loggedInCondition
        confirmationButton?.isEnabled = isEnabled
        confirmationButton?.alpha = isEnabled ? 1 : 0.5
    }

    func checkAuth() {
        guard let loggedIn = dependencies?.authProvider.loggedIn else {
            return
        }

        onUnauthorizedView?.isHidden = loggedIn
        checkConfirmationButtonEnabled()
    }

    private func handleBetResult(bet: Bet) {
        currentBetOutcome = ""
        currentBetType = nil

        setResultBetLabel(didWin: bet.didWin ?? false)
        resultingDiceImageView?.image = UIImage(named: "dice\(bet.outcome ?? 0)")
    }

}
