//
//  BetsHistoryViewController.swift
//  VirtualSports
//
//  Created by Vsevolod Pavlovskyi on 27.03.2021.
//

import UIKit
import APILayer

protocol BetsShowing {
    var bets: [Bet] { get }
    var onDismiss: (() -> Void)? { get set }
}

final class BetsHistoryViewController: UIViewController, BetsShowing {

    var onDismiss: (() -> Void)?
    var bets: [Bet]

    @IBOutlet weak var stackView: UIStackView?

    override func viewDidLoad() {
        super.viewDidLoad()

        bets
            .reversed()
            .map({ BetView(bet: $0) })
            .forEach({ stackView?.addArrangedSubview($0) })
    }

    init(bets: [Bet]) {
        self.bets = bets

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        log.info("Close button tapped")
        onDismiss?()
    }
}

final class BetView: UIView {

    lazy var stackView: UIStackView = {

        let stackView = UIStackView()

        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        return stackView
    }()

    lazy var timeLabel: UILabel = {

        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.text = bet.dateTime

        return label
    }()

    lazy var outcomeLabel: UILabel = {

        let label = UILabel()

        guard let outcome = bet.outcome else {
            return label
        }

        label.attributedText = makeColoredString(title: "ИСХОД",
                                                 value: "\(outcome) - \(outcome % 2 == 0 ? "ЧЕТ" : "НЕЧЕТ")")

        return label
    }()

    lazy var betLabel: UILabel = {

        let label = UILabel()

        let coloredText: String

        switch bet.betType {
        case 0..<6:
            coloredText = "\(bet.betType + 1)"
        case 6:
            coloredText = "ЧЕТ"
        case 7:
            coloredText = "НЕЧЕТ"
        default:
            coloredText = ""
        }

        label.attributedText = makeColoredString(title: "СТАВКА", value: coloredText)

        return label
    }()

    lazy var resultLabel: UILabel = {

        let label = UILabel()

        guard let didWin = bet.didWin else {
            return label
        }

        label.attributedText = makeColoredString(title: "РЕЗУЛЬТАТ",
                                                 value: "\(didWin ? "ПОБЕДА" : "ПОРАЖЕНИЕ")",
                                                 color: didWin ? UIColor(named: "PMGreen") : .systemRed)

        return label
    }()

    private let bet: Bet

    init(bet: Bet) {

        self.bet = bet

        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension BetView {

    func setup() {

        layer.backgroundColor = UIColor(named: "Background")?.cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        [timeLabel, outcomeLabel, betLabel, resultLabel]
            .forEach({ stackView.addArrangedSubview($0) })

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    func makeColoredString(title: String, value: String,
                           color: UIColor? = UIColor(named: "PMYellow")) -> NSMutableAttributedString {
        let fullText = title + ": " + value

        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.setColor(color: color ?? .yellow, forText: value)

        return attributedString
    }

}

extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(.foregroundColor, value: color, range: range)
    }

}
